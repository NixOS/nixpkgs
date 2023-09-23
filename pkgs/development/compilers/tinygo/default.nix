{ stdenv
, lib
, buildPackages
, buildGoModule
, fetchFromGitHub
, makeWrapper
, substituteAll
, llvmPackages
, go
, libffi
, zlib
, ncurses
, libxml2
, xar
, wasi-libc
, avrgcc
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
    ln -s ${lib.getBin lld}/bin/ld.lld $out/ld.lld-${llvmMajor}
    ln -s ${lib.getBin lld}/bin/wasm-ld $out/wasm-ld-${llvmMajor}
    ln -s ${gdb}/bin/gdb $out/gdb-multiarch
  '';
in

buildGoModule rec {
  pname = "tinygo";
  version = "0.26.0";

  src = fetchFromGitHub {
    owner = "tinygo-org";
    repo = "tinygo";
    rev = "v${version}";
    sha256 = "rI8CADPWKdNvfknEsrpp2pCeZobf9fAp0GDIWjupzZA=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-ihQd/RAjAQhgQZHbNiWmAD0eOo1MvqAR/OwIOUWtdAM=";

  patches = [
    ./0001-Makefile.patch

    (substituteAll {
      src = ./0002-Add-clang-header-path.patch;
      clang_include = "${clang.cc.lib}/lib/clang/${clang.cc.version}/include";
    })

    #TODO(muscaln): Find a better way to fix build ID on darwin
    ./0003-Use-out-path-as-build-id-on-darwin.patch
  ];

  nativeCheckInputs = [ avrgcc binaryen ];
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ llvm clang.cc ]
    ++ lib.optionals stdenv.isDarwin [ zlib ncurses libffi libxml2 xar ];

  doCheck = (stdenv.buildPlatform.canExecute stdenv.hostPlatform);
  inherit tinygoTests;

  allowGoReference = true;
  tags = [ "llvm${llvmMajor}" ];
  ldflags = [ "-X github.com/tinygo-org/tinygo/goenv.TINYGOROOT=${placeholder "out"}/share/tinygo" ];
  subPackages = [ "." ];

  # Output contains static libraries for different arm cpus
  # and stripping could mess up these so only strip the compiler
  stripDebugList = [ "bin" ];

  postConfigure = lib.optionalString stdenv.isDarwin ''
    for i in vendor/tinygo.org/x/go-llvm/llvm_config_darwin*; do
      substituteInPlace $i --replace "curses" "ncurses"
    done
  '';

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

    substituteInPlace Makefile \
      --replace "\$(TINYGO)" "$(pwd)/build/tinygo" \
      --replace "@\$(MD5SUM)" "md5sum" \
      --replace "build/release/tinygo/bin" "$out/bin" \
      --replace "build/release/" "$out/share/"

    substituteInPlace builder/buildid.go \
      --replace "OUT_PATH" "$out"

    # TODO: Fix mingw and darwin
    # Disable windows and darwin cross-compile tests
    sed -i "/GOOS=windows/d" Makefile
    sed -i "/GOOS=darwin/d" Makefile
  '' + lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
    substituteInPlace Makefile \
      --replace "./build/tinygo" "${buildPackages.tinygo}/bin/tinygo"
  '';

  preBuild = ''
    export PATH=${bootstrapTools}:$PATH
    export HOME=$TMPDIR
  '';

  postBuild = let
    tinygoForBuild = if (stdenv.buildPlatform.canExecute stdenv.hostPlatform)
      then "build/tinygo"
      else "${buildPackages.tinygo}/bin/tinygo";
    in ''
    # Move binary
    mkdir -p build
    mv $GOPATH/bin/tinygo build/tinygo

    make gen-device

    export TINYGOROOT=$(pwd)
    finalRoot=$out/share/tinygo

    for target in thumbv6m-unknown-unknown-eabi-cortex-m0 thumbv6m-unknown-unknown-eabi-cortex-m0plus thumbv7em-unknown-unknown-eabi-cortex-m4; do
      mkdir -p $finalRoot/pkg/$target
      for lib in compiler-rt picolibc; do
        ${tinygoForBuild} build-library -target=''${target#*eabi-} -o $finalRoot/pkg/$target/$lib $lib
      done
    done
  '';

  checkPhase = lib.optionalString (tinygoTests != [ ] && tinygoTests != null) ''
    make ''${tinygoTests[@]} XTENSA=0 ${lib.optionalString stdenv.isDarwin "AVR=0"}
  '';

  installPhase = ''
    runHook preInstall

    make build/release

    wrapProgram $out/bin/tinygo \
      --prefix PATH : ${lib.makeBinPath [ go avrdude openocd avrgcc binaryen ]}:${bootstrapTools}

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
