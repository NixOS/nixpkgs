{ stdenv, buildPackages, fetchFromGitHub, lib }:

stdenv.mkDerivation {
  pname = "wasilibc";
  version = "unstable-2022-04-12";

  src = buildPackages.fetchFromGitHub {
    owner = "WebAssembly";
    repo = "wasi-libc";
    rev = "a279514a6ef30cd8ee1469345b33172fcbc8d52d";
    sha256 = "0a9ldas8p7jg7jlkhb9wdiw141z7vfz6p18mnmxnnnna7bp1y3fz";
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
    )
  '';

  enableParallelBuilding = true;

  # We just build right into the install paths, per the `preBuild`.
  dontInstall = true;

  preFixup = ''
    ln -s $share/share/undefined-symbols.txt $out/lib/wasi.imports
  '';

  meta = with lib; {
    description = "WASI libc implementation for WebAssembly";
    homepage = "https://wasi.dev";
    platforms = platforms.wasi;
    maintainers = with maintainers; [ matthewbauer ];
    license = with licenses; [ asl20 mit llvm-exception ];
  };
}
