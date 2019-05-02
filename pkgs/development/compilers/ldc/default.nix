{ stdenv, fetchurl, cmake, ninja, llvm, llvm_8, curl, tzdata
, python, libconfig, lit, gdb, unzip, darwin, bash
, callPackage, makeWrapper, targetPackages
, bootstrapVersion ? false
, version ? "1.15.0"
, ldcSha256 ? "1qnfy2q8zkywvby7wa8jm20mlpghn28x6w357cpc8hi56g7y1q6p"
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

in

stdenv.mkDerivation rec {
  name = "ldc-${version}";

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
  ''

  + stdenv.lib.optionalString (!bootstrapVersion && stdenv.hostPlatform.isDarwin) ''
      # https://github.com/NixOS/nixpkgs/issues/34817
      rm -r ldc-${version}-src/tests/plugins/addFuncEntryCall
  ''

  + stdenv.lib.optionalString (!bootstrapVersion) ''
      echo ${tzdata}/share/zoneinfo/ > ldc-${version}-src/TZDatabaseDirFile

      echo ${curl.out}/lib/libcurl${stdenv.hostPlatform.extensions.sharedLibrary} > ldc-${version}-src/LibcurlPathFile
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

  ++ stdenv.lib.optional (!bootstrapVersion) [
    bootstrapLdc python lit
  ]

  ++ stdenv.lib.optional (!bootstrapVersion && stdenv.hostPlatform.isDarwin) [
    # https://github.com/NixOS/nixpkgs/issues/57120
    # https://github.com/NixOS/nixpkgs/pull/59197#issuecomment-481972515
    llvm
  ]

  ++ stdenv.lib.optional (!bootstrapVersion && !stdenv.hostPlatform.isDarwin) [
    llvm_8
  ]

  ++ stdenv.lib.optional (!bootstrapVersion && !stdenv.hostPlatform.isDarwin) [
    # https://github.com/NixOS/nixpkgs/pull/36378#issuecomment-385034818
    gdb
  ]

  ++ stdenv.lib.optional (bootstrapVersion) [
    libconfig llvm
  ]

  ++ stdenv.lib.optional stdenv.hostPlatform.isDarwin (with darwin.apple_sdk.frameworks; [
    Foundation
  ]);


  buildInputs = [ curl tzdata ];

  cmakeFlagsString = stdenv.lib.optionalString (!bootstrapVersion) ''
    "-DD_FLAGS=-d-version=TZDatabaseDir;-d-version=LibcurlPath;-J$PWD"
    "-DCMAKE_BUILD_TYPE=Release"
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

  fixNames = if stdenv.hostPlatform.isDarwin then ''
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
  ''
  else
    "";

  # https://github.com/ldc-developers/ldc/issues/2497#issuecomment-459633746
  additionalExceptions = if stdenv.hostPlatform.isDarwin then
    "|druntime-test-shared"
  else
    "";

  doCheck = !bootstrapVersion && !stdenv.isDarwin;

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

