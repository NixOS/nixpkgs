{ stdenv
, buildPackages
, fetchFromGitHub
, lib
# Enable experimental wasilibc pthread support
, enableThreads ? false
# For tests
, firefox-unwrapped
, firefox-esr-unwrapped
, pkgsCross
, wasmtime
}:

let
  pname = "wasilibc";
  version = "20";
in
stdenv.mkDerivation {
  inherit pname version;

  src = buildPackages.fetchFromGitHub {
    owner = "WebAssembly";
    repo = "wasi-libc";
    rev = "refs/tags/wasi-sdk-${version}";
    sha256 = "0knm5ch499dksmv1k0kh7356pjd9n1gjn0p3vp9bw57mn478zp8z";
    fetchSubmodules = true;
  };

  outputs = [ "out" "dev" "share" ];

  # clang-13: error: argument unused during compilation: '-rtlib=compiler-rt' [-Werror,-Wunused-command-line-argument]
  postPatch = ''
    substituteInPlace Makefile \
      --replace "-Werror" ""
  '';

  preBuild = ''
    export SYSROOT_LIB=${builtins.placeholder "out"}/lib
    export SYSROOT_INC=${builtins.placeholder "dev"}/include
    export SYSROOT_SHARE=${builtins.placeholder "share"}/share
    mkdir -p "$SYSROOT_LIB" "$SYSROOT_INC" "$SYSROOT_SHARE"
    makeFlagsArray+=(
      "SYSROOT_LIB:=$SYSROOT_LIB"
      "SYSROOT_INC:=$SYSROOT_INC"
      "SYSROOT_SHARE:=$SYSROOT_SHARE"
      "THREAD_MODEL=${if enableThreads then "posix" else "single"}"
    )

  '';

  enableParallelBuilding = true;

  # We just build right into the install paths, per the `preBuild`.
  dontInstall = true;

  preFixup = ''
    ln -s $share/share/undefined-symbols.txt $out/lib/wasi.imports
  '';

  passthru = {
    tests = {
      inherit firefox-unwrapped firefox-esr-unwrapped;
      simple-c-cxx-binaries = pkgsCross.wasi32.runCommandCC "simple-c-cxx-binaries" {
        nativeBuildInputs = [
          wasmtime
        ];
      } ''
        cat > test.c <<EOF
        #include <stdio.h>
        int main(void) {
          puts("Hello from C");
          return 0;
        }
        EOF
        cat > test.cpp <<EOF
        #include <iostream>
        int main(void) {
          std::cout<<"Hello from C++\n";
          return 0;
        }
        EOF

        mkdir -p "$out/bin"
        # TODO(@sternenseemann): compile with -pthread if enableThreads
        $CC -o "$out/bin/test-c" test.c
        $CXX -o "$out/bin/test-cxx" test.cpp -lc++ -lc++abi

        export HOME=$TMPDIR
        export WASMTIME_FLAGS=(${
          lib.escapeShellArgs (lib.optionals enableThreads [
            "--wasm-features=threads"
            "--wasi-modules=experimental-wasi-threads"
          ])
        })
        wasmtime run "''${WASMTIME_FLAGS[@]}" "$out/bin/test-c"
        wasmtime run "''${WASMTIME_FLAGS[@]}" "$out/bin/test-cxx"
      '';
    };
    hasThreads = enableThreads;
  };

  meta = with lib; {
    changelog = "https://github.com/WebAssembly/wasi-sdk/releases/tag/wasi-sdk-${version}";
    description = "WASI libc implementation for WebAssembly";
    homepage = "https://wasi.dev";
    platforms = platforms.wasi;
    maintainers = with maintainers; [ matthewbauer rvolosatovs ];
    license = with licenses; [ asl20-llvm mit ];
  };
}
