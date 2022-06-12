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
}:

let
  llvmMajor = lib.versions.major llvm.version;
  inherit (llvmPackages) llvm clang compiler-rt lld;
in

buildGoModule rec {
  pname = "tinygo";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "tinygo-org";
    repo = "tinygo";
    rev = "v${version}";
    sha256 = "sha256-YgQGAQJw9Xyw5BF2d9uZTQHfjHsu2evZGo4RV9DtStE=";
    fetchSubmodules = true;
  };

  vendorSha256 = "sha256-fK8BlCh+1NtHW6MwW68iSIB+Sw6AK+g3y4lMyMYrXkk=";

  patches = [
    ./0001-Makefile.patch

    (substituteAll {
      src = ./0002-Add-clang-header-path.patch;
      clang_include = "${clang.cc.lib}/lib/clang/${clang.cc.version}/include";
    })
  ];

  checkInputs = [ avrgcc binaryen ];
  nativeBuildInputs = [ go makeWrapper ];
  buildInputs = [ llvm clang.cc ]
    ++ lib.optionals stdenv.isDarwin [ zlib ncurses libffi libxml2 xar ];

  doCheck = stdenv.buildPlatform == stdenv.hostPlatform;

  allowGoReference = true;
  tags = [ "llvm${llvmMajor}" ];
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
      --replace "build/release/tinygo/bin" "$out/bin" \
      --replace "build/release/" "$out/share/"

    # TODO: Fix mingw and darwin
    # Disable windows and darwin cross-compile tests
    sed -i "/GOOS=windows/d" Makefile
    sed -i "/GOOS=darwin/d" Makefile

    # tinygo needs versioned binaries
    mkdir -p $out/libexec/tinygo
    ln -s ${lib.getBin clang.cc}/bin/clang $out/libexec/tinygo/clang-${llvmMajor}
    ln -s ${lib.getBin lld}/bin/ld.lld $out/libexec/tinygo/ld.lld-${llvmMajor}
    ln -s ${lib.getBin lld}/bin/wasm-ld $out/libexec/tinygo/wasm-ld-${llvmMajor}
    ln -s ${gdb}/bin/gdb $out/libexec/tinygo/gdb-multiarch
  '' + lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
    substituteInPlace Makefile \
      --replace "./build/tinygo" "${buildPackages.tinygo}/bin/tinygo"
  '';

  preBuild = ''
    export HOME=$TMPDIR
    export GOCACHE=$TMPDIR/go-cache
    export GOPATH=$TMPDIR/go
    export PATH=$out/libexec/tinygo:$PATH
  '';

  postBuild = ''
    # Move binary
    mkdir -p build
    mv $GOPATH/bin/tinygo build/tinygo

    make gen-device
  '';

  checkPhase = ''
    runHook preCheck
    make smoketest XTENSA=0
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    make build/release

    wrapProgram $out/bin/tinygo \
      --set TINYGOROOT $out/share/tinygo \
      --prefix PATH : ${lib.makeBinPath [ go avrdude openocd avrgcc binaryen ]}:$out/libexec/tinygo

    runHook postInstall
  '';

  disallowedReferences = [ wasi-libc ];

  meta = with lib; {
    homepage = "https://tinygo.org/";
    description = "Go compiler for small places";
    license = licenses.bsd3;
    maintainers = with maintainers; [ Madouura muscaln ];
    broken = stdenv.isDarwin;
  };
}
