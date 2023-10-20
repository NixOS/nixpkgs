{ stdenv
, lib
, buildPackages
, buildGoModule
, fetchFromGitHub
, makeWrapper
, llvmPackages
, go
, xar
, wasi-libc
, binaryen
, avrdude
, gdb
, openocd
, runCommand
, tinygoTests ? [ "smoketest" ]
}:

let
  llvmMajor = lib.versions.major llvm.version;
  inherit (llvmPackages) llvm clang compiler-rt lld;

  # only doing this because only on darwin placing clang.cc in nativeBuildInputs
  # doesn't build
  bootstrapTools = runCommand "tinygo-bootstap-tools" { } ''
    mkdir -p $out
    ln -s ${lib.getBin clang.cc}/bin/clang $out/clang-${llvmMajor}
  '';
in

buildGoModule rec {
  pname = "tinygo";
  version = "0.31.1";

  src = fetchFromGitHub {
    owner = "tinygo-org";
    repo = "tinygo";
    rev = "v${version}";
    sha256 = "sha256-YocRTgGSyjnQsYd4a2nCQ0vdQi/z2gHPguix5xIkkgc=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-HZiyAgsTEBQv+Qp0T9RXTV1lkxvIGh7Q45rd45cfvjo=";

  patches = [
    ./0001-GNUmakefile.patch
  ];

  nativeCheckInputs = [ binaryen ];
  nativeBuildInputs = [ makeWrapper lld ];
  buildInputs = [ llvm clang.cc ]
    ++ lib.optionals stdenv.isDarwin [ xar ];

  doCheck = (stdenv.buildPlatform.canExecute stdenv.hostPlatform);
  inherit tinygoTests;

  allowGoReference = true;
  ldflags = [
    "-X github.com/tinygo-org/tinygo/goenv.TINYGOROOT=${placeholder "out"}/share/tinygo"
    "-X github.com/tinygo-org/tinygo/goenv.clangResourceDir=${clang.cc.lib}/lib/clang/${llvmMajor}"
  ];
  subPackages = [ "." ];

  # Output contains static libraries for different arm cpus
  # and stripping could mess up these so only strip the compiler
  stripDebugList = [ "bin" ];

  postPatch = ''
    # Copy wasi-libc, symlink seems not working
    rm -rf lib/wasi-libc/*
    mkdir -p lib/wasi-libc/sysroot/lib/wasm32-wasi lib/wasi-libc/sysroot/include
    cp -a ${wasi-libc}/lib/* lib/wasi-libc/sysroot/lib/wasm32-wasi/
    cp -a ${wasi-libc.dev}/include/* lib/wasi-libc/sysroot/include/

    # Borrow compiler-rt builtins from our source
    # See https://github.com/tinygo-org/tinygo/pull/2471
    mkdir -p lib/compiler-rt-builtins
    cp -a ${compiler-rt.src}/compiler-rt/lib/builtins/* lib/compiler-rt-builtins/

    substituteInPlace GNUmakefile \
      --replace "build/release/tinygo/bin" "$out/bin" \
      --replace "build/release/" "$out/share/"
  '';

  preBuild = ''
    export PATH=${bootstrapTools}:$PATH
    export HOME=$TMPDIR
  '';

  postBuild = ''
    # Move binary
    mkdir -p build
    mv $GOPATH/bin/tinygo build/tinygo

    make gen-device -j $NIX_BUILD_CORES

    export TINYGOROOT=$(pwd)
  '';

  checkPhase = lib.optionalString (tinygoTests != [ ] && tinygoTests != null) ''
    make ''${tinygoTests[@]} TINYGO="$(pwd)/build/tinygo" MD5SUM=md5sum XTENSA=0
  '';

  # GDB upstream does not support ARM darwin
  runtimeDeps = [ go clang.cc lld avrdude openocd binaryen ]
    ++ lib.optionals (!(stdenv.isDarwin && stdenv.isAarch64)) [ gdb ];

  installPhase = ''
    runHook preInstall

    make build/release

    wrapProgram $out/bin/tinygo \
      --prefix PATH : ${lib.makeBinPath runtimeDeps }

    runHook postInstall
  '';

  disallowedReferences = [ wasi-libc ];

  meta = with lib; {
    homepage = "https://tinygo.org/";
    description = "Go compiler for small places";
    license = licenses.bsd3;
    maintainers = with maintainers; [ Madouura muscaln ];
  };
}
