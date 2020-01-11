{ stdenv, fetchurl, cmake, ninja, llvm_5, llvm_8, curl, tzdata
, python, libconfig, lit, gdb, unzip, darwin, bash
, callPackage, makeWrapper, runCommand, targetPackages
, bootstrapVersion ? false
, version ? "1.17.0"
, ldcSha256 ? "1aag5jfrng6p4ms0fs90hjbv9bcj3hj8h52r68c3cm6racdajbva"
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

  pathConfig = runCommand "ldc-lib-paths" {} ''
    mkdir $out
    echo ${tzdata}/share/zoneinfo/ > $out/TZDatabaseDirFile
    echo ${curl.out}/lib/libcurl${stdenv.hostPlatform.extensions.sharedLibrary} > $out/LibcurlPathFile
  '';
in

stdenv.mkDerivation rec {
  pname = "ldc";
  inherit version;

  enableParallelBuilding = true;

  src = fetchurl {
    url = "https://github.com/ldc-developers/ldc/releases/download/v${version}/ldc-${version}-src.tar.gz";
    sha256 = ldcSha256;
  };

  # https://issues.dlang.org/show_bug.cgi?id=19553
  hardeningDisable = [ "fortify" ];

  postUnpack = ''
    patchShebangs .
  ''

  + stdenv.lib.optionalString (!bootstrapVersion) ''
      rm ldc-${version}-src/tests/d2/dmd-testsuite/fail_compilation/mixin_gc.d
      rm ldc-${version}-src/tests/d2/dmd-testsuite/runnable/xtest46_gc.d
      rm ldc-${version}-src/tests/d2/dmd-testsuite/runnable/testptrref_gc.d

      # test depends on current year
      rm ldc-${version}-src/tests/d2/dmd-testsuite/compilable/ddocYear.d
  ''

  + stdenv.lib.optionalString (!bootstrapVersion && stdenv.hostPlatform.isDarwin) ''
      # https://github.com/NixOS/nixpkgs/issues/34817
      rm -r ldc-${version}-src/tests/plugins/addFuncEntryCall
  '';

  postPatch = ''
      # Setting SHELL=$SHELL when dmd testsuite is run doesn't work on Linux somehow
      substituteInPlace tests/d2/dmd-testsuite/Makefile --replace "SHELL=/bin/bash" "SHELL=${bash}/bin/bash"
    ''

  + stdenv.lib.optionalString (!bootstrapVersion && stdenv.hostPlatform.isLinux) ''
      substituteInPlace runtime/phobos/std/socket.d --replace "assert(ih.addrList[0] == 0x7F_00_00_01);" ""
  ''

  + stdenv.lib.optionalString (!bootstrapVersion && stdenv.hostPlatform.isDarwin) ''
      substituteInPlace runtime/phobos/std/socket.d --replace "foreach (name; names)" "names = []; foreach (name; names)"
  ''

  + stdenv.lib.optionalString (bootstrapVersion && stdenv.hostPlatform.isDarwin) ''
      # Was not able to compile on darwin due to "__inline_isnanl"
      # being undefined.
      # TODO Remove with version > 0.17.6
      substituteInPlace dmd2/root/port.c --replace __inline_isnanl __inline_isnan
  '';

  nativeBuildInputs = [ cmake ninja makeWrapper unzip ]
    ++ stdenv.lib.optionals (!bootstrapVersion) [
      bootstrapLdc python lit
    ]
    ++ stdenv.lib.optional (!bootstrapVersion && stdenv.hostPlatform.isDarwin)
      # https://github.com/NixOS/nixpkgs/issues/57120
      # https://github.com/NixOS/nixpkgs/pull/59197#issuecomment-481972515
      llvm_5
    ++ stdenv.lib.optional (!bootstrapVersion && !stdenv.hostPlatform.isDarwin)
      llvm_8
    ++ stdenv.lib.optional (!bootstrapVersion && !stdenv.hostPlatform.isDarwin)
      # https://github.com/NixOS/nixpkgs/pull/36378#issuecomment-385034818
      gdb
    ++ stdenv.lib.optionals (bootstrapVersion) [
      libconfig llvm_5
    ]
    ++ stdenv.lib.optional stdenv.hostPlatform.isDarwin
      darwin.apple_sdk.frameworks.Foundation;


  buildInputs = [ curl tzdata ];

  cmakeFlags = stdenv.lib.optionals (!bootstrapVersion) [
    "-DD_FLAGS=-d-version=TZDatabaseDir;-d-version=LibcurlPath;-J${pathConfig}"
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  postConfigure = ''
    export DMD=$PWD/bin/ldmd2
  '';

  makeFlags = [ "DMD=$DMD" ];

  fixNames = stdenv.lib.optionalString stdenv.hostPlatform.isDarwin  ''
    fixDarwinDylibNames() {
      local flags=()

      for fn in "$@"; do
        flags+=(-change "$(basename "$fn")" "$fn")
      done

      for fn in "$@"; do
        if [ -L "$fn" ]; then continue; fi
        echo "$fn: fixing dylib"
        install_name_tool -id "$fn" "''${flags[@]}" "$fn"
      done
    }

    fixDarwinDylibNames $(find "$(pwd)/lib" -name "*.dylib")
    export DYLD_LIBRARY_PATH=$(pwd)/lib
  '';

  # https://github.com/ldc-developers/ldc/issues/2497#issuecomment-459633746
  additionalExceptions = stdenv.lib.optionalString stdenv.hostPlatform.isDarwin
    "|druntime-test-shared";

  doCheck = !bootstrapVersion;

  checkPhase = stdenv.lib.optionalString doCheck ''
    # Build default lib test runners
    ninja -j$NIX_BUILD_CORES all-test-runners

    ${fixNames}

    # Run dmd testsuite
    export DMD_TESTSUITE_MAKE_ARGS="-j$NIX_BUILD_CORES DMD=$DMD CC=$CXX"
    ctest -V -R "dmd-testsuite"

    # Build and run LDC D unittests.
    ctest --output-on-failure -R "ldc2-unittest"

    # Run LIT testsuite.
    ctest -V -R "lit-tests"

    # Run default lib unittests
    ctest -j$NIX_BUILD_CORES --output-on-failure -E "ldc2-unittest|lit-tests|dmd-testsuite${additionalExceptions}"
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
}

