{ stdenv, fetchurl, cmake, llvm, curl, tzdata
, python, libconfig, lit, gdb, unzip, darwin, bash
, callPackage, makeWrapper, targetPackages
, bootstrapVersion ? false
, version ? "1.12.0"
, ldcSha256 ? "1fdma1w8j37wkr0pqdar11slkk36qymamxnk6d9k8ybhjmxaaawm"
}:

let
  bootstrapLdc = if !bootstrapVersion then
    # LDC 0.17.x is the last version which doesn't need a working D compiler to
    # build so we use that version to bootstrap the actual build.
    callPackage ./default.nix {
      bootstrapVersion = true;
      version = "0.17.6";
      ldcSha256 = "0qf5kbxddgmg3kqzi0kf4bgv8vdrnv16y07hcpm0cwv9mc3qr2w6";
    }
  else
    "";

  ldcBuild = stdenv.mkDerivation rec {
    name = "ldcBuild-${version}";

    enableParallelBuilding = true;

    src = fetchurl {
      url = "https://github.com/ldc-developers/ldc/releases/download/v${version}/ldc-${version}-src.tar.gz";
      sha256 = ldcSha256;
    };

    postUnpack = ''
        patchShebangs .
    ''

    + stdenv.lib.optionalString (!bootstrapVersion && stdenv.hostPlatform.isDarwin) ''
        # http://forum.dlang.org/thread/xtbbqthxutdoyhnxjhxl@forum.dlang.org
        rm -r ldc-${version}-src/tests/dynamiccompile

        # https://github.com/NixOS/nixpkgs/issues/34817
        rm -r ldc-${version}-src/tests/plugins/addFuncEntryCall

        # https://github.com/NixOS/nixpkgs/pull/36378#issuecomment-385034818
        rm -r ldc-${version}-src/tests/debuginfo/classtypes_gdb.d
        rm -r ldc-${version}-src/tests/debuginfo/nested_gdb.d

        rm ldc-${version}-src/tests/d2/dmd-testsuite/runnable/test16096.sh
        rm ldc-${version}-src/tests/d2/dmd-testsuite/compilable/ldc_output_filenames.sh
        rm ldc-${version}-src/tests/d2/dmd-testsuite/compilable/crlf.sh
        rm ldc-${version}-src/tests/d2/dmd-testsuite/compilable/issue15574.sh
        rm ldc-${version}-src/tests/d2/dmd-testsuite/compilable/test6461.sh
    ''

    + stdenv.lib.optionalString (!bootstrapVersion) ''
        echo ${tzdata}/share/zoneinfo/ > ldc-${version}-src/TZDatabaseDirFile

        # Remove cppa test for now because it doesn't work.
        rm ldc-${version}-src/tests/d2/dmd-testsuite/runnable/cppa.d
        rm ldc-${version}-src/tests/d2/dmd-testsuite/runnable/extra-files/cppb.cpp
    '';

    datetimePath = if bootstrapVersion then
      "phobos/std/datetime.d"
    else
      "phobos/std/datetime/timezone.d";

    postPatch = ''
        # https://issues.dlang.org/show_bug.cgi?id=15391
        substituteInPlace runtime/phobos/std/net/curl.d \
            --replace libcurl.so ${curl.out}/lib/libcurl.so

        substituteInPlace tests/d2/dmd-testsuite/Makefile \
            --replace "SHELL=/bin/bash" "SHELL=${bash}/bin/bash"
    ''

    + stdenv.lib.optionalString (bootstrapVersion && stdenv.hostPlatform.isDarwin) ''
        # Was not able to compile on darwin due to "__inline_isnanl"
        # being undefined.
        substituteInPlace dmd2/root/port.c --replace __inline_isnanl __inline_isnan
    '';

    nativeBuildInputs = [ cmake makeWrapper llvm bootstrapLdc python lit gdb unzip ]

    ++ stdenv.lib.optional (bootstrapVersion) [
      libconfig
    ]

    ++ stdenv.lib.optional stdenv.hostPlatform.isDarwin (with darwin.apple_sdk.frameworks; [
      Foundation
    ]);


    buildInputs = [ curl tzdata ];

    #"-DINCLUDE_INSTALL_DIR=$out/include/dlang/ldc"
    # Xcode 9.0.1 fixes that bug according to ldc release notes
    #"-DRT_ARCHIVE_WITH_LDC=OFF"
      #"-DD_FLAGS=TZ_DATABASE_DIR=${tzdata}/share/zoneinfo/"
      #"-DCMAKE_BUILD_TYPE=Release"
      #"-DCMAKE_SKIP_RPATH=ON"

      #-DINCLUDE_INSTALL_DIR=$out/include/dlang/ldc
      #
    cmakeFlagsString = stdenv.lib.optionalString (!bootstrapVersion) ''
      "-DD_FLAGS=-d-version=TZDatabaseDir;-J$PWD"
    '';

    preConfigure = stdenv.lib.optionalString (!bootstrapVersion) ''
      cmakeFlagsArray=(
        ${cmakeFlagsString}
      )
    '';

    postConfigure = ''
      export DMD=$PWD/bin/ldmd2
    '';

    makeFlags = [ "DMD=$DMD" ];

    doCheck = !bootstrapVersion;

    checkPhase = ''
      # Build and run LDC D unittests.
      ctest --output-on-failure -R "ldc2-unittest"
      # Run LIT testsuite.
      ctest -V -R "lit-tests"
      # Run DMD testsuite.
      DMD_TESTSUITE_MAKE_ARGS=-j$NIX_BUILD_CORES ctest -V -R "dmd-testsuite"
    '';

    postInstall = ''
      wrapProgram $out/bin/ldc2 \
          --prefix PATH ":" "${targetPackages.stdenv.cc}/bin" \
          --set-default CC "${targetPackages.stdenv.cc}/bin/cc"
     '';

    meta = with stdenv.lib; {
      description = "The LLVM-based D compiler";
      homepage = https://github.com/ldc-developers/ldc;
      # from https://github.com/ldc-developers/ldc/blob/master/LICENSE
      license = with licenses; [ bsd3 boost mit ncsa gpl2Plus ];
      maintainers = with maintainers; [ ThomasMader ];
      platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" ];
    };
  };

  # Need to test Phobos in a fixed-output derivation, otherwise the
  # network stuff in Phobos would fail if sandbox mode is enabled.
  #
  # Disable tests on Darwin for now because of
  # https://github.com/NixOS/nixpkgs/issues/41099
  # https://github.com/NixOS/nixpkgs/pull/36378#issuecomment-385034818
  ldcUnittests = if (!bootstrapVersion && !stdenv.hostPlatform.isDarwin) then
    stdenv.mkDerivation rec {
      name = "ldcUnittests-${version}";

      enableParallelBuilding = ldcBuild.enableParallelBuilding;
      preferLocalBuild = true;
      inputString = ldcBuild.outPath;
      outputHashAlgo = "sha256";
      outputHash = builtins.hashString "sha256" inputString;

      src = ldcBuild.src;

      postUnpack = ldcBuild.postUnpack;

      postPatch = ldcBuild.postPatch;

      nativeBuildInputs = ldcBuild.nativeBuildInputs

      ++ [
        ldcBuild
      ];

      buildInputs = ldcBuild.buildInputs;

      preConfigure = ''
        cmakeFlagsArray=(
          ${ldcBuild.cmakeFlagsString}
          "-DD_COMPILER=${ldcBuild.out}/bin/ldmd2"
        )
      '';

      postConfigure = ldcBuild.postConfigure;

      makeFlags = ldcBuild.makeFlags;

      buildCmd = if bootstrapVersion then
        "ctest -V -R \"build-druntime-ldc-unittest|build-phobos2-ldc-unittest\""
      else
        "make -j$NIX_BUILD_CORES DMD=${ldcBuild.out}/bin/ldc2 phobos2-test-runner phobos2-test-runner-debug";

      testCmd = if bootstrapVersion then
        "ctest -j$NIX_BUILD_CORES --output-on-failure -E \"dmd-testsuite|lit-tests|ldc2-unittest|llvm-ir-testsuite\""
      else
        "ctest -j$NIX_BUILD_CORES --output-on-failure -E \"dmd-testsuite|lit-tests|ldc2-unittest\"";

      buildPhase = ''
          ${buildCmd}
          ln -s ${ldcBuild.out}/bin/ldmd2 $PWD/bin/ldmd2
          ${testCmd}
      '';

      installPhase = ''
          echo -n $inputString > $out
      '';
    }
  else
    "";

in

stdenv.mkDerivation rec {
  inherit ldcUnittests;
  name = "ldc-${version}";
  phases = "installPhase";
  buildInputs = ldcBuild.buildInputs;

  installPhase = ''
    mkdir $out
    cp -r --symbolic-link ${ldcBuild}/* $out/
  '';

  meta = ldcBuild.meta;
}

