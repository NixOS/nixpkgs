{ stdenv, fetchurl, cmake, llvm, curl, tzdata
, python, libconfig, lit, gdb, unzip, darwin, bash
, callPackage, makeWrapper, targetPackages
, bootstrapVersion ? false
, version ? "1.11.0"
, ldcSha256 ? "0w4z261gzji31hn1xdnmi9dfkbyydpy6rz8aj4456q5w8yp4yil5"
}:

let

  bootstrapLdc = if !bootstrapVersion then
    # LDC 0.17.x is the last version which doesn't need a working D compiler to
    # build so we use that version to bootstrap the actual build.
    callPackage ./default.nix {
      bootstrapVersion = true;
      version = "0.17.5";
      ldcSha256 = "0200r5y8hs5yv2cx24csgyh00dlg18877b9cfblixypr6nhl19bs";
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

        # Remove cppa test for now because it doesn't work.
        rm ldc-${version}-src/tests/d2/dmd-testsuite/runnable/cppa.d
        rm ldc-${version}-src/tests/d2/dmd-testsuite/runnable/extra-files/cppb.cpp
    ''

    + stdenv.lib.optionalString (bootstrapVersion) ''
        # ... runnable/variadic.d            ()
        #Test failed.  The logged output:
        #/tmp/nix-build-ldcBuild-0.17.5.drv-0/ldc-0.17.5-src/build/bin/ldmd2 -conf= -m64 -Irunnable   -od/tmp/nix-build-ldcBuild-0.17.5.drv-0/ldc-0.17.5-src/build/dmd-testsuite/runnable -of/tmp/nix-build-ldcBuild-0.17.5.drv-0/ldc-0.17.5-src/build/dmd-testsuite/runnable/variadic_0 runnable/variadic.d
        #Error: integer constant expression expected instead of <cant>
        #Error: integer constant expression expected instead of <cant>
        #Error: integer constant expression expected instead of <cant>
        #Error: integer constant expression expected instead of <cant>
        #Error: integer constant expression expected instead of <cant>
        #runnable/variadic.d(84): Error: template instance variadic.Foo3!(int, int, int) error instantiating
        #
        #
        #==============================
        #Test failed: expected rc == 0, exited with rc == 1
        rm ldc-${version}-src/tests/d2/dmd-testsuite/runnable/variadic.d
    ''

    + stdenv.lib.optionalString (!bootstrapVersion) ''
	    # http://forum.dlang.org/thread/xtbbqthxutdoyhnxjhxl@forum.dlang.org
	    rm -r ldc-${version}-src/tests/dynamiccompile

            # https://github.com/NixOS/nixpkgs/issues/34817
	    rm -r ldc-${version}-src/tests/plugins/addFuncEntryCall
    '';

    ROOT_HOME_DIR = "$(echo ~root)";

    datetimePath = if bootstrapVersion then
      "phobos/std/datetime.d"
    else
      "phobos/std/datetime/timezone.d";

    postPatch = ''
        substituteInPlace runtime/${datetimePath} \
            --replace "import core.time;" "import core.time;import std.path;"

        substituteInPlace runtime/${datetimePath} \
            --replace "tzName == \"leapseconds\"" "baseName(tzName) == \"leapseconds\""

        substituteInPlace runtime/phobos/std/net/curl.d \
            --replace libcurl.so ${curl.out}/lib/libcurl.so

        # Ugly hack to fix the hardcoded path to zoneinfo in the source file.
        # https://issues.dlang.org/show_bug.cgi?id=15391
        substituteInPlace runtime/${datetimePath} \
            --replace /usr/share/zoneinfo/ ${tzdata}/share/zoneinfo/

        substituteInPlace tests/d2/dmd-testsuite/Makefile \
            --replace "SHELL=/bin/bash" "SHELL=${bash}/bin/bash"
    ''

    + stdenv.lib.optionalString stdenv.hostPlatform.isLinux ''
        # See https://github.com/NixOS/nixpkgs/issues/29443
        substituteInPlace runtime/phobos/std/path.d \
            --replace "\"/root" "\"${ROOT_HOME_DIR}"

        # Can be remove with front end version >= 2.078.0
        substituteInPlace runtime/druntime/src/core/memory.d \
            --replace "assert(z is null);" "//assert(z is null);"
    ''

    + stdenv.lib.optionalString (bootstrapVersion && stdenv.hostPlatform.isDarwin) ''
        # https://github.com/ldc-developers/ldc/pull/2306
        # Can be removed on bootstrap version > 0.17.5
        substituteInPlace gen/programs.cpp \
            --replace "gcc" "clang"

        # Was not able to compile on darwin due to "__inline_isnanl"
        # being undefined.
        substituteInPlace dmd2/root/port.c --replace __inline_isnanl __inline_isnan
    ''

    + stdenv.lib.optionalString (!bootstrapVersion) ''
        # TODO Can be removed with the next ldc version > 1.7.0
        # https://github.com/ldc-developers/ldc/issues/2493
        substituteInPlace tests/d2/dmd-testsuite/Makefile \
            --replace "# disable tests based on arch" "DISABLED_TESTS += test_cdvecfill"
    ''

    + stdenv.lib.optionalString (bootstrapVersion) ''
        substituteInPlace runtime/${datetimePath} \
            --replace "import std.traits;" "import std.traits;import std.path;"

        substituteInPlace runtime/${datetimePath} \
            --replace "tzName == \"+VERSION\"" "baseName(tzName) == \"leapseconds\" || tzName == \"+VERSION\""
    '';

    nativeBuildInputs = [ cmake makeWrapper llvm bootstrapLdc python lit gdb unzip ]

    ++ stdenv.lib.optional (bootstrapVersion) [
      libconfig
    ]

    ++ stdenv.lib.optional stdenv.hostPlatform.isDarwin (with darwin.apple_sdk.frameworks; [
      Foundation
    ]);


    buildInputs = [ curl tzdata ];

    preConfigure = ''
      cmakeFlagsArray=("-DINCLUDE_INSTALL_DIR=$out/include/dlang/ldc"
                       "-DCMAKE_BUILD_TYPE=Release"
                       "-DCMAKE_SKIP_RPATH=ON"
                       "-DBUILD_SHARED_LIBS=OFF"
                       "-DLDC_WITH_LLD=OFF"
                       # Xcode 9.0.1 fixes that bug according to ldc release notes
                       "-DRT_ARCHIVE_WITH_LDC=OFF"
                      )
    '';


    postConfigure = ''
      export DMD=$PWD/bin/ldmd2
    '';

    makeFlags = [ "DMD=$DMD" ];

    # Disable tests on Darwin for now because of
    # https://github.com/NixOS/nixpkgs/issues/41099
    # https://github.com/NixOS/nixpkgs/pull/36378#issuecomment-385034818
    doCheck = !bootstrapVersion && !stdenv.hostPlatform.isDarwin;

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
        cmakeFlagsArray=( "-DINCLUDE_INSTALL_DIR=$out/include/dlang/ldc"
                          "-DCMAKE_BUILD_TYPE=Release"
                          "-DCMAKE_SKIP_RPATH=ON"
                          "-DBUILD_SHARED_LIBS=OFF"
                          "-DLDC_WITH_LLD=OFF"
                          # Xcode 9.0.1 fixes that bug according to ldc release notes
                          "-DRT_ARCHIVE_WITH_LDC=OFF"
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

