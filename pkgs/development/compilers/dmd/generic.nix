{ version
, dmdSha256
, druntimeSha256
, phobosSha256
}:

{ stdenv
, lib
, fetchFromGitHub
, makeWrapper
, which
, writeTextFile
, curl
, tzdata
, gdb
, Foundation
, callPackage
, targetPackages
, fetchpatch
, bash
, installShellFiles
, git
, unzip
, HOST_DMD ? "${callPackage ./bootstrap.nix { }}/bin/dmd"
}:

let
  dmdConfFile = writeTextFile {
    name = "dmd.conf";
    text = (lib.generators.toINI { } {
      Environment = {
        DFLAGS = ''-I@out@/include/dmd -L-L@out@/lib -fPIC ${lib.optionalString (!targetPackages.stdenv.cc.isClang) "-L--export-dynamic"}'';
      };
    });
  };

  bits = builtins.toString stdenv.hostPlatform.parsed.cpu.bits;
  osname =
    if stdenv.isDarwin then
      "osx"
    else
      stdenv.hostPlatform.parsed.kernel.name;

  pathToDmd = "\${NIX_BUILD_TOP}/dmd/generated/${osname}/release/${bits}/dmd";
in

stdenv.mkDerivation rec {
  pname = "dmd";
  inherit version;

  enableParallelBuilding = true;

  srcs = [
    (fetchFromGitHub {
      owner = "dlang";
      repo = "dmd";
      rev = "v${version}";
      sha256 = dmdSha256;
      name = "dmd";
    })
    (fetchFromGitHub {
      owner = "dlang";
      repo = "druntime";
      rev = "v${version}";
      sha256 = druntimeSha256;
      name = "druntime";
    })
    (fetchFromGitHub {
      owner = "dlang";
      repo = "phobos";
      rev = "v${version}";
      sha256 = phobosSha256;
      name = "phobos";
    })
  ];

  sourceRoot = ".";

  # https://issues.dlang.org/show_bug.cgi?id=19553
  hardeningDisable = [ "fortify" ];

  patches = lib.optionals (lib.versionOlder version "2.088.0") [
    # Migrates D1-style operator overloads in DMD source, to allow building with
    # a newer DMD
    (fetchpatch {
      url = "https://github.com/dlang/dmd/commit/c4d33e5eb46c123761ac501e8c52f33850483a8a.patch";
      stripLen = 1;
      extraPrefix = "dmd/";
      sha256 = "sha256-N21mAPfaTo+zGCip4njejasraV5IsWVqlGR5eOdFZZE=";
    })
  ] ++ lib.optionals (lib.versionOlder version "2.092.2") [
    # Fixes C++ tests that compiled on older C++ but not on the current one
    (fetchpatch {
      url = "https://github.com/dlang/druntime/commit/438990def7e377ca1f87b6d28246673bb38022ab.patch";
      stripLen = 1;
      extraPrefix = "druntime/";
      sha256 = "sha256-/pPKK7ZK9E/mBrxm2MZyBNhYExE8p9jz8JqBdZSE6uY=";
    })
  ];

  postPatch = ''
    patchShebangs dmd/test/{runnable,fail_compilation,compilable,tools}{,/extra-files}/*.sh

    rm dmd/test/runnable/gdb1.d
    rm dmd/test/runnable/gdb10311.d
    rm dmd/test/runnable/gdb14225.d
    rm dmd/test/runnable/gdb14276.d
    rm dmd/test/runnable/gdb14313.d
    rm dmd/test/runnable/gdb14330.d
    rm dmd/test/runnable/gdb15729.sh
    rm dmd/test/runnable/gdb4149.d
    rm dmd/test/runnable/gdb4181.d

    # Disable tests that rely on objdump whitespace until fixed upstream:
    #   https://issues.dlang.org/show_bug.cgi?id=23317
    rm dmd/test/runnable/cdvecfill.sh
    rm dmd/test/compilable/cdcmp.d

    # Grep'd string changed with gdb 12
    #   https://issues.dlang.org/show_bug.cgi?id=23198
    substituteInPlace druntime/test/exceptions/Makefile \
      --replace 'in D main (' 'in _Dmain ('

    # We're using gnused on all platforms
    substituteInPlace druntime/test/coverage/Makefile \
      --replace 'freebsd osx' 'none'
  ''

  + lib.optionalString (lib.versionOlder version "2.091.0") ''
    # This one has tested against a hardcoded year, then against a current year on
    # and off again. It just isn't worth it to patch all the historical versions
    # of it, so just remove it until the most recent change.
    rm dmd/test/compilable/ddocYear.d
  '' + lib.optionalString (lib.versionAtLeast version "2.089.0" && lib.versionOlder version "2.092.2") ''
    rm dmd/test/dshell/test6952.d
  '' + lib.optionalString (lib.versionAtLeast version "2.092.2") ''
    substituteInPlace dmd/test/dshell/test6952.d --replace "/usr/bin/env bash" "${bash}/bin/bash"
  ''

  + lib.optionalString stdenv.isLinux ''
    substituteInPlace phobos/std/socket.d --replace "assert(ih.addrList[0] == 0x7F_00_00_01);" ""
  '' + lib.optionalString stdenv.isDarwin ''
    substituteInPlace phobos/std/socket.d --replace "foreach (name; names)" "names = []; foreach (name; names)"
  '';

  nativeBuildInputs = [
    makeWrapper
    which
    installShellFiles
  ] ++ lib.optionals (lib.versionOlder version "2.088.0") [
    git
  ];

  buildInputs = [
    curl
    tzdata
  ] ++ lib.optionals stdenv.isDarwin [
    Foundation
  ];

  nativeCheckInputs = [
    gdb
  ] ++ lib.optionals (lib.versionOlder version "2.089.0") [
    unzip
  ];

  buildFlags = [
    "BUILD=release"
    "ENABLE_RELEASE=1"
    "PIC=1"
  ];

  # Build and install are based on http://wiki.dlang.org/Building_DMD
  buildPhase = ''
    runHook preBuild

    export buildJobs=$NIX_BUILD_CORES
    if [ -z $enableParallelBuilding ]; then
      buildJobs=1
    fi

    make -C dmd -f posix.mak $buildFlags -j$buildJobs HOST_DMD=${HOST_DMD}
    make -C druntime -f posix.mak $buildFlags -j$buildJobs DMD=${pathToDmd}
    echo ${tzdata}/share/zoneinfo/ > TZDatabaseDirFile
    echo ${lib.getLib curl}/lib/libcurl${stdenv.hostPlatform.extensions.sharedLibrary} > LibcurlPathFile
    make -C phobos -f posix.mak $buildFlags -j$buildJobs DMD=${pathToDmd} DFLAGS="-version=TZDatabaseDir -version=LibcurlPath -J$PWD"

    runHook postBuild
  '';

  doCheck = true;

  checkFlags = buildFlags;

  # many tests are disbled because they are failing

  # NOTE: Purity check is disabled for checkPhase because it doesn't fare well
  # with the DMD linker. See https://github.com/NixOS/nixpkgs/issues/97420
  checkPhase = ''
    runHook preCheck

    export checkJobs=$NIX_BUILD_CORES
    if [ -z $enableParallelChecking ]; then
      checkJobs=1
    fi

    NIX_ENFORCE_PURITY= \
      make -C dmd/test $checkFlags CC=$CXX SHELL=$SHELL -j$checkJobs N=$checkJobs

    NIX_ENFORCE_PURITY= \
      make -C druntime -f posix.mak unittest $checkFlags -j$checkJobs

    NIX_ENFORCE_PURITY= \
      make -C phobos -f posix.mak unittest $checkFlags -j$checkJobs DFLAGS="-version=TZDatabaseDir -version=LibcurlPath -J$PWD"

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 ${pathToDmd} $out/bin/dmd

    installManPage dmd/docs/man/man*/*

    mkdir -p $out/include/dmd
    cp -r {druntime/import/*,phobos/{std,etc}} $out/include/dmd/

    mkdir $out/lib
    cp phobos/generated/${osname}/release/${bits}/libphobos2.* $out/lib/

    wrapProgram $out/bin/dmd \
      --prefix PATH ":" "${targetPackages.stdenv.cc}/bin" \
      --set-default CC "${targetPackages.stdenv.cc}/bin/cc"

    substitute ${dmdConfFile} "$out/bin/dmd.conf" --subst-var out

    runHook postInstall
  '';

  meta = with lib; {
    description = "Official reference compiler for the D language";
    homepage = "https://dlang.org/";
    # Everything is now Boost licensed, even the backend.
    # https://github.com/dlang/dmd/pull/6680
    license = licenses.boost;
    maintainers = with maintainers; [ ThomasMader lionello dukc ];
    platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" ];
  };
}
