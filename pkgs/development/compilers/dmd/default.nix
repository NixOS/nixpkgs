{ stdenv, fetchFromGitHub, overrideCC, gcc5
, makeWrapper, unzip, which
, curl, tzdata, gdb, darwin
, callPackage
, bootstrapVersion ? false
, version ? "2.079.0"
, dmdSha256 ? "1k6cky71pqnss6h6391p1ich2mjs598f5fda018aygnxg87qgh4y"
, druntimeSha256 ? "183pqygj5w4105czs5kswyjn9mrcybx3wmkynz3in0m3ylzzjmvl"
, phobosSha256 ? "0y9i86ggmf41ww2xk2bsrlsv9b1blj5dbyan6q6r6xp8dmgrd79w"
}:

let

  bootstrapDmd = if !bootstrapVersion then
    # Versions 2.070.2 and up require a working dmd compiler to build so we just
    # use the last dmd without any D code to bootstrap the actual build.
    callPackage ./default.nix {
      stdenv = if stdenv.hostPlatform.isDarwin then
                 stdenv
               else
                 # Doesn't build with gcc6 on linux
                 overrideCC stdenv gcc5;
      bootstrapVersion = true;
      version = "2.067.1";
      dmdSha256 = "0fm29lg8axfmzdaj0y6vg70lhwb5d9rv4aavnvdd15xjschinlcz";
      druntimeSha256 = "1n2qfw9kmnql0fk2nxikispqs7vh85nhvyyr00fk227n9lgnqf02";
      phobosSha256 = "0fywgds9xvjcgnqxmpwr67p3wi2m535619pvj159cgwv5y0nr3p1";
    }
  else
    "";

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

    datetimePath = if bootstrapVersion then
      "phobos/std/datetime.d"
    else
      "phobos/std/datetime/timezone.d";

    phobosPatches = ''
        # Ugly hack so the dlopen call has a chance to succeed.
        # https://issues.dlang.org/show_bug.cgi?id=15391
        substituteInPlace phobos/std/net/curl.d \
            --replace libcurl.so ${curl.out}/lib/libcurl.so

        # phobos uses curl, so we need to patch the path to the lib.
        substituteInPlace phobos/posix.mak \
            --replace "-soname=libcurl.so.4" "-soname=${curl.out}/lib/libcurl.so.4"

    ''

    + stdenv.lib.optionalString (!bootstrapVersion) ''
	# Can be removed when https://github.com/dlang/phobos/pull/6224 is included.
        substituteInPlace ${datetimePath} \
            --replace "foreach (DirEntry de; dirEntries(tzDatabaseDir, SpanMode.depth))" "import std.path : baseName; foreach (DirEntry de; dirEntries(tzDatabaseDir, SpanMode.depth))"

        substituteInPlace ${datetimePath} \
            --replace "tzName == \"leapseconds\"" "baseName(tzName) == \"leapseconds\""
    ''

    + stdenv.lib.optionalString (bootstrapVersion) ''
        substituteInPlace ${datetimePath} \
            --replace "import std.traits;" "import std.traits;import std.path;"

        substituteInPlace ${datetimePath} \
            --replace "tzName == \"+VERSION\"" "baseName(tzName) == \"leapseconds\" || tzName == \"+VERSION\""

        # Ugly hack to fix the hardcoded path to zoneinfo in the source file.
        # https://issues.dlang.org/show_bug.cgi?id=15391
        substituteInPlace ${datetimePath} \
            --replace /usr/share/zoneinfo/ ${tzdata}/share/zoneinfo/
    ''

    + stdenv.lib.optionalString (bootstrapVersion && stdenv.hostPlatform.isLinux) ''
        # See https://github.com/dlang/phobos/pull/5960
        substituteInPlace phobos/std/path.d \
            --replace "\"/root" "\"${ROOT_HOME_DIR}"
    '';

    dmdPath = if bootstrapVersion then
      "dmd/src"
    else
      "dmd";

    postPatch = ''
    ''

    + stdenv.lib.optionalString (!bootstrapVersion) ''
        substituteInPlace druntime/test/common.mak \
            --replace "DFLAGS:=" "DFLAGS:=${usePIC} "
    ''

    + stdenv.lib.optionalString (bootstrapVersion) ''
        # Use proper C++ compiler
        substituteInPlace ${dmdPath}/posix.mak \
            --replace g++ $CXX
    ''

    + phobosPatches

    + stdenv.lib.optionalString (stdenv.hostPlatform.isLinux && bootstrapVersion) ''
      substituteInPlace ${dmdPath}/root/port.c \
        --replace "#include <bits/mathdef.h>" "#include <complex.h>"
    ''

    + stdenv.lib.optionalString stdenv.hostPlatform.isDarwin ''
        substituteInPlace ${dmdPath}/posix.mak \
            --replace MACOSX_DEPLOYMENT_TARGET MACOSX_DEPLOYMENT_TARGET_
    ''

    + stdenv.lib.optionalString (stdenv.hostPlatform.isDarwin && bootstrapVersion) ''
	    # Was not able to compile on darwin due to "__inline_isnanl"
	    # being undefined.
	    substituteInPlace ${dmdPath}/root/port.c --replace __inline_isnanl __inline_isnan
    '';

    nativeBuildInputs = [ bootstrapDmd makeWrapper unzip which gdb ]

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
    pathToDmd = if bootstrapVersion then
      "${top}/dmd/src/dmd"
    else
      "${top}/dmd/generated/${osname}/release/${bits}/dmd";

    # Buid and install are based on http://wiki.dlang.org/Building_DMD
    buildPhase = ''
        cd dmd
        make -j$NIX_BUILD_CORES -f posix.mak INSTALL_DIR=$out
        cd ../druntime
        make -j$NIX_BUILD_CORES -f posix.mak PIC=1 INSTALL_DIR=$out DMD=${pathToDmd}
        cd ../phobos
        make -j$NIX_BUILD_CORES -f posix.mak PIC=1 INSTALL_DIR=$out DMD=${pathToDmd} TZ_DATABASE_DIR=${tzdata}/share/zoneinfo/
        cd ..
    '';

    doCheck = !bootstrapVersion;

    checkPhase = ''
        cd dmd
        make -j$NIX_BUILD_CORES -C test -f Makefile PIC=1 DMD=${pathToDmd} BUILD=release SHARED=0 SHELL=$SHELL
        cd ../druntime
        make -j$NIX_BUILD_CORES -f posix.mak unittest PIC=1 DMD=${pathToDmd} BUILD=release
        cd ..
    '';
    
    extension = if stdenv.hostPlatform.isDarwin then "a" else "{a,so}";

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
            --prefix PATH ":" "${stdenv.cc}/bin" \
            --set-default CC "$CC"

        cd $out/bin
        tee dmd.conf << EOF
        [Environment]
        DFLAGS=-I$out/include/d2 -L-L$out/lib ${stdenv.lib.optionalString (!stdenv.cc.isClang) "-L--export-dynamic"} -fPIC
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
  phobosUnittests = stdenv.mkDerivation rec {
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
        make -j$NIX_BUILD_CORES -f posix.mak unittest PIC=1 DMD=${dmdBuild}/bin/dmd BUILD=release TZ_DATABASE_DIR=${tzdata}/share/zoneinfo/
    '';

    installPhase = ''
        echo -n $inputString > $out
    '';
  };

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

