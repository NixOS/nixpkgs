{
  stdenv,
  buildPackages,
  lib,
  fetchzip,
  gpm,
  libffi,
  libGL,
  libX11,
  libXext,
  libXpm,
  libXrandr,
  ncurses,
}:

stdenv.mkDerivation rec {
  pname = "fbc";
  version = "1.10.1";

  src = fetchzip {
    # Bootstrap tarball has sources pretranslated from FreeBASIC to C
    url = "https://github.com/freebasic/fbc/releases/download/${version}/FreeBASIC-${version}-source-bootstrap.tar.xz";
    hash = "sha256-LBROv3m1DrEfSStMbNuLC+fldYNfSS+D09bJyNMNPP0=";
  };

  postPatch = ''
    patchShebangs tests/warnings/test.sh
  '';

  dontConfigure = true;

  depsBuildBuild = [
    buildPackages.stdenv.cc
    buildPackages.ncurses
    buildPackages.libffi
  ];

  buildInputs = [
    ncurses
    libffi
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    gpm
    libGL
    libX11
    libXext
    libXpm
    libXrandr
  ];

  enableParallelBuilding = true;

  hardeningDisable = [
    "format"
  ];

  makeFlags = lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "TARGET=${stdenv.hostPlatform.config}"
  ];

  preBuild = ''
    export buildJobs=$NIX_BUILD_CORES
    if [ -z "$enableParallelBuilding" ]; then
      buildJobs=1
    fi

    echo Bootstrap an unpatched build compiler
    make bootstrap-minimal -j$buildJobs \
      BUILD_PREFIX=${buildPackages.stdenv.cc.targetPrefix} LD=${buildPackages.stdenv.cc.targetPrefix}ld

    echo Compile patched build compiler and host rtlib
    make compiler -j$buildJobs \
      "FBC=$PWD/bin/fbc${stdenv.buildPlatform.extensions.executable} -i $PWD/inc" \
      BUILD_PREFIX=${buildPackages.stdenv.cc.targetPrefix} LD=${buildPackages.stdenv.cc.targetPrefix}ld
    make rtlib -j$buildJobs \
      "FBC=$PWD/bin/fbc${stdenv.buildPlatform.extensions.executable} -i $PWD/inc" \
      ${
        if (stdenv.buildPlatform == stdenv.hostPlatform) then
          "BUILD_PREFIX=${buildPackages.stdenv.cc.targetPrefix} LD=${buildPackages.stdenv.cc.targetPrefix}ld"
        else
          "TARGET=${stdenv.hostPlatform.config}"
      }

    echo Install patched build compiler and host rtlib to local directory
    make install-compiler prefix=$PWD/patched-fbc
    make install-rtlib prefix=$PWD/patched-fbc ${
      lib.optionalString (
        stdenv.buildPlatform != stdenv.hostPlatform
      ) "TARGET=${stdenv.hostPlatform.config}"
    }
    make clean

    echo Compile patched host everything with previous patched stage
    buildFlagsArray+=("FBC=$PWD/patched-fbc/bin/fbc${stdenv.buildPlatform.extensions.executable} -i $PWD/inc")
  '';

  installFlags = [
    "prefix=${placeholder "out"}"
  ];

  # Tests do not work when cross-compiling even if build platform can execute
  # host binaries, compiler struggles to find the cross compiler's libgcc_s
  doCheck = stdenv.buildPlatform == stdenv.hostPlatform;

  checkTarget = "unit-tests warning-tests log-tests";

  checkFlags = [
    "UNITTEST_RUN_ARGS=--verbose" # see what unit-tests are doing
    "ABORT_CMD=false" # abort log-tests on failure
  ];

  checkPhase = ''
    runHook preCheck

    # Some tests fail with too much parallelism
    export maxCheckJobs=50
    export checkJobs=$(($NIX_BUILD_CORES<=$maxCheckJobs ? $NIX_BUILD_CORES : $maxCheckJobs))
    if [ -z "$enableParallelChecking" ]; then
      checkJobs=1
    fi

    # Run check targets in series, else the logs are a mess
    for target in $checkTarget; do
      make $target -j$checkJobs $makeFlags $checkFlags
    done

    runHook postCheck
  '';

  meta = with lib; {
    homepage = "https://www.freebasic.net/";
    description = "Multi-platform BASIC Compiler";
    mainProgram = "fbc";
    longDescription = ''
      FreeBASIC is a completely free, open-source, multi-platform BASIC compiler (fbc),
      with syntax similar to (and support for) MS-QuickBASIC, that adds new features
      such as pointers, object orientation, unsigned data types, inline assembly,
      and many others.
    '';
    license = licenses.gpl2Plus; # runtime & graphics libraries are LGPLv2+ w/ static linking exception
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = with platforms; windows ++ linux;
  };
}
