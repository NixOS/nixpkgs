{ stdenv, fetchFromGitHub
, makeWrapper, unzip, which
, curl, tzdata, gdb, darwin
, callPackage, targetPackages, ldc
, version ? "2.081.2"
, dmdSha256 ? "1wwk4shqldvgyczv1ihmljpfj3yidq7mxcj69i9kjl7jqx54hw62"
, druntimeSha256 ? "0dqfsy34q2q7mk2gsi4ix3vgqg7szg3m067fghgx53vnvrzlpsc0"
, phobosSha256 ? "1dan59lc4wggsrv5aax7jsxnzg7fz37xah84k1cbwjb3xxhhkd9n"
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

    postUnpack = ''
        patchShebangs .

        # Remove cppa test for now because it doesn't work.
        rm dmd/test/runnable/cppa.d
        rm dmd/test/runnable/extra-files/cppb.cpp
    '';

    # Compile with PIC to prevent colliding modules with binutils 2.28.
    # https://issues.dlang.org/show_bug.cgi?id=17375
    usePIC = "-fPIC";
    ROOT_HOME_DIR = "$(echo ~root)";

    phobosPatches = ''
        # Ugly hack so the dlopen call has a chance to succeed.
        # https://issues.dlang.org/show_bug.cgi?id=15391
        substituteInPlace phobos/std/net/curl.d \
            --replace libcurl.so ${curl.out}/lib/libcurl.so

        # phobos uses curl, so we need to patch the path to the lib.
        substituteInPlace phobos/posix.mak \
            --replace "-soname=libcurl.so.4" "-soname=${curl.out}/lib/libcurl.so.4"

    '';

    postPatch = ''
        substituteInPlace druntime/test/common.mak \
            --replace "DFLAGS:=" "DFLAGS:=${usePIC} "

        substituteInPlace dmd/src/posix.mak \
            --replace "DFLAGS :=" "DFLAGS += -link-defaultlib-shared=false"
    ''

    + phobosPatches

    + stdenv.lib.optionalString stdenv.hostPlatform.isDarwin ''
        substituteInPlace dmd/posix.mak \
            --replace MACOSX_DEPLOYMENT_TARGET MACOSX_DEPLOYMENT_TARGET_
    '';

    nativeBuildInputs = [ ldc makeWrapper unzip which gdb ]

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
        make -j$NIX_BUILD_CORES -f posix.mak BUILD=release ENABLE_RELEASE=1 PIC=1 INSTALL_DIR=$out DMD=${pathToDmd} TZ_DATABASE_DIR=${tzdata}/share/zoneinfo/
        cd ..
    '';

    # Disable tests on Darwin for now because of
    # https://github.com/NixOS/nixpkgs/issues/41099
    doCheck = !stdenv.hostPlatform.isDarwin;

    checkPhase = ''
        cd dmd
        make -j$NIX_BUILD_CORES -C test -f Makefile PIC=1 DMD=${pathToDmd} BUILD=release SHARED=0 SHELL=$SHELL
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

      postPatch = dmdBuild.phobosPatches;

      nativeBuildInputs = dmdBuild.nativeBuildInputs;
      buildInputs = dmdBuild.buildInputs;

      buildPhase = ''
          cd phobos
          make -j$NIX_BUILD_CORES -f posix.mak unittest BUILD=release ENABLE_RELEASE=1 PIC=1 DMD=${dmdBuild}/bin/dmd TZ_DATABASE_DIR=${tzdata}/share/zoneinfo/
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

