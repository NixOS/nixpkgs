{ stdenv, fetchFromGitHub
, makeWrapper, unzip, which
, curl, tzdata, gdb, darwin, git
, callPackage, targetPackages, ldc
, version ? "2.084.0"
, dmdSha256 ? "1v61spdamncl8c1bzjc19b03p4jl0ih5zq9b7cqsy9ix7qaxmikf"
, druntimeSha256 ? "0vp414j6s11l9s54v81np49mv60ywmd7nnk41idkbwrq0nz4sfrq"
, phobosSha256 ? "1wp7z1x299b0w9ny1ah2wrfhrs05vc4bk51csgw9774l3dqcnv53"
}:

let

  dmdBuild = stdenv.mkDerivation rec {
    name = "dmdBuild-${version}";
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

    postUnpack = ''
        patchShebangs .
    '';

    postPatch = ''
        substituteInPlace dmd/test/compilable/extra-files/ddocYear.html \
            --replace "2018" "__YEAR__"

        substituteInPlace dmd/test/runnable/test16096.sh \
            --replace "{EXT}" "{EXE}"
    '';

    nativeBuildInputs = [ ldc makeWrapper unzip which gdb git ]

    ++ stdenv.lib.optional stdenv.hostPlatform.isDarwin (with darwin.apple_sdk.frameworks; [
      Foundation
    ]);

    buildInputs = [ curl tzdata ];

    bits = builtins.toString stdenv.hostPlatform.parsed.cpu.bits;
    osname = if stdenv.hostPlatform.isDarwin then
      "osx"
    else
      stdenv.hostPlatform.parsed.kernel.name;
    top = "$(echo $NIX_BUILD_TOP)";
    pathToDmd = "${top}/dmd/generated/${osname}/release/${bits}/dmd";

    # Buid and install are based on http://wiki.dlang.org/Building_DMD
    buildPhase = ''
        cd dmd
        make -j$NIX_BUILD_CORES -f posix.mak INSTALL_DIR=$out BUILD=release ENABLE_RELEASE=1 PIC=1 HOST_DMD=ldmd2
        cd ../druntime
        make -j$NIX_BUILD_CORES -f posix.mak BUILD=release ENABLE_RELEASE=1 PIC=1 INSTALL_DIR=$out DMD=${pathToDmd}
        cd ../phobos
        echo ${tzdata}/share/zoneinfo/ > TZDatabaseDirFile
        echo ${curl.out}/lib/libcurl.so > LibcurlPathFile
        make -j$NIX_BUILD_CORES -f posix.mak BUILD=release ENABLE_RELEASE=1 PIC=1 INSTALL_DIR=$out DMD=${pathToDmd} DFLAGS="-version=TZDatabaseDir -version=LibcurlPath -J$(pwd)"
        cd ..
    '';

    # Disable tests on Darwin for now because of
    # https://github.com/NixOS/nixpkgs/issues/41099
    doCheck = true;

    checkPhase = ''
        cd dmd
        make -j$NIX_BUILD_CORES -C test -f Makefile PIC=1 CC=$CXX DMD=${pathToDmd} BUILD=release SHARED=0 SHELL=$SHELL
        cd ../druntime
        make -j$NIX_BUILD_CORES -f posix.mak unittest PIC=1 DMD=${pathToDmd} BUILD=release
        cd ..
    '';

    extension = if stdenv.hostPlatform.isDarwin then "a" else "{a,so}";
    
    dontStrip = true;

    installPhase = ''
        cd dmd
        mkdir $out
        mkdir $out/bin
        cp ${pathToDmd} $out/bin

        mkdir -p $out/share/man/man1
        mkdir -p $out/share/man/man5
        cp -r docs/man/man1/* $out/share/man/man1/
        cp -r docs/man/man5/* $out/share/man/man5/

        cd ../druntime
        mkdir $out/include
        mkdir $out/include/d2
        cp -r import/* $out/include/d2

        cd ../phobos
        mkdir $out/lib
        cp generated/${osname}/release/${bits}/libphobos2.${extension} $out/lib

        cp -r std $out/include/d2
        cp -r etc $out/include/d2

        wrapProgram $out/bin/dmd \
            --prefix PATH ":" "${targetPackages.stdenv.cc}/bin" \
            --set-default CC "${targetPackages.stdenv.cc}/bin/cc"

        cd $out/bin
        tee dmd.conf << EOF
        [Environment]
        DFLAGS=-I$out/include/d2 -L-L$out/lib ${stdenv.lib.optionalString (!targetPackages.stdenv.cc.isClang) "-L--export-dynamic"} -fPIC
        EOF
    '';

    meta = with stdenv.lib; {
      description = "Official reference compiler for the D language";
      homepage = http://dlang.org/;
      # Everything is now Boost licensed, even the backend.
      # https://github.com/dlang/dmd/pull/6680
      license = licenses.boost;
      maintainers = with maintainers; [ ThomasMader ];
      platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" ];
    };
  };

  # Need to test Phobos in a fixed-output derivation, otherwise the
  # network stuff in Phobos would fail if sandbox mode is enabled.
  #
  # Disable tests on Darwin for now because of
  # https://github.com/NixOS/nixpkgs/issues/41099
  phobosUnittests = if !stdenv.hostPlatform.isDarwin then
    stdenv.mkDerivation rec {
      name = "phobosUnittests-${version}";
      version = dmdBuild.version;

      enableParallelBuilding = dmdBuild.enableParallelBuilding;
      preferLocalBuild = true;
      inputString = dmdBuild.outPath;
      outputHashAlgo = "sha256";
      outputHash = builtins.hashString "sha256" inputString;

      srcs = dmdBuild.srcs;

      sourceRoot = ".";

      nativeBuildInputs = dmdBuild.nativeBuildInputs;
      buildInputs = dmdBuild.buildInputs;

      buildPhase = ''
          cd phobos
          echo ${tzdata}/share/zoneinfo/ > TZDatabaseDirFile
          echo ${curl.out}/lib/libcurl.so > LibcurlPathFile
          make -j$NIX_BUILD_CORES -f posix.mak unittest BUILD=release ENABLE_RELEASE=1 PIC=1 DMD=${dmdBuild}/bin/dmd DFLAGS="-version=TZDatabaseDir -version=LibcurlPath -J$(pwd)"
      '';

      installPhase = ''
          echo -n $inputString > $out
      '';
    }
  else
    "";

in

stdenv.mkDerivation rec {
  inherit phobosUnittests;
  name = "dmd-${version}";
  phases = "installPhase";
  buildInputs = dmdBuild.buildInputs;

  installPhase = ''
    mkdir $out
    cp -r --symbolic-link ${dmdBuild}/* $out/
  '';
  meta = dmdBuild.meta;
}

