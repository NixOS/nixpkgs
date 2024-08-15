{ lib
, gccStdenv
, stdenv
, fetchurl
, cmake
, nasm

  # NUMA support enabled by default on NUMA platforms:
, numaSupport ? (stdenv.hostPlatform.isLinux && (stdenv.hostPlatform.isx86 || stdenv.hostPlatform.isAarch64))
, numactl

  # Multi bit-depth support (8bit+10bit+12bit):
, multibitdepthSupport ? (stdenv.is64bit && !(stdenv.isAarch64 && stdenv.isLinux))

  # Other options:
, cliSupport ? true # Build standalone CLI application
, custatsSupport ? false # Internal profiling of encoder work
, debugSupport ? false # Run-time sanity checks (debugging)
, ppaSupport ? false # PPA profiling instrumentation
, unittestsSupport ? stdenv.isx86_64 # Unit tests - only testing x64 assembly
, vtuneSupport ? false # Vtune profiling instrumentation
, werrorSupport ? false # Warnings as errors
}:

let
  mkFlag = optSet: flag: if optSet then "-D${flag}=ON" else "-D${flag}=OFF";

  isCross = stdenv.buildPlatform != stdenv.hostPlatform;
in

stdenv.mkDerivation rec {
  pname = "x265";
  version = "3.6";

  outputs = [ "out" "dev" ];

  # Check that x265Version.txt contains the expected version number
  # whether we fetch a source tarball or a tag from the git repo
  src = fetchurl {
    url = "https://bitbucket.org/multicoreware/x265_git/downloads/x265_${version}.tar.gz";
    hash = "sha256-ZjUx80HFOJ9GDXMOYuEKT8yjQoyiyhCWk4Z7xf4uKAc=";
  };

  # TODO: apply patch unconditionally in staging. It's conditional to
  # save rebuild on staging-next.
  patches = lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [
    ./darwin-__rdtsc.patch
  ];

  sourceRoot = "x265_${version}/source";

  postPatch = ''
    substituteInPlace cmake/Version.cmake \
      --replace "unknown" "${version}" \
      --replace "0.0" "${version}"
  ''
  # There is broken and complicated logic when setting X265_LATEST_TAG for
  # mingwW64 builds. This bypasses the logic by setting it at the end of the
  # file
  + lib.optionalString stdenv.hostPlatform.isMinGW ''
    echo 'set(X265_LATEST_TAG "${version}")' >> ./cmake/Version.cmake
  '';

  nativeBuildInputs = [ cmake nasm ] ++ lib.optionals (numaSupport) [ numactl ];

  cmakeFlags = [
    "-Wno-dev"
    (mkFlag custatsSupport "DETAILED_CU_STATS")
    (mkFlag debugSupport "CHECKED_BUILD")
    (mkFlag ppaSupport "ENABLE_PPA")
    (mkFlag vtuneSupport "ENABLE_VTUNE")
    (mkFlag werrorSupport "WARNINGS_AS_ERRORS")
  ]
    # Clang does not support the endfunc directive so use GCC.
    ++ lib.optional (stdenv.cc.isClang && !stdenv.targetPlatform.isDarwin) "-DCMAKE_ASM_COMPILER=${gccStdenv.cc}/bin/${gccStdenv.cc.targetPrefix}gcc";

  cmakeStaticLibFlags = [
    "-DHIGH_BIT_DEPTH=ON"
    "-DENABLE_CLI=OFF"
    "-DENABLE_SHARED=OFF"
    "-DEXPORT_C_API=OFF"
  ] ++ lib.optionals stdenv.hostPlatform.isPower [
    "-DENABLE_ALTIVEC=OFF" # https://bitbucket.org/multicoreware/x265_git/issues/320/fail-to-build-on-power8-le
  ];

  preConfigure = lib.optionalString multibitdepthSupport ''
    cmake -B build-10bits $cmakeFlags "''${cmakeFlagsArray[@]}" $cmakeStaticLibFlags
    cmake -B build-12bits $cmakeFlags "''${cmakeFlagsArray[@]}" $cmakeStaticLibFlags -DMAIN12=ON
    cmakeFlagsArray+=(
      -DEXTRA_LIB="x265-10.a;x265-12.a"
      -DEXTRA_LINK_FLAGS=-L.
      -DLINKED_10BIT=ON
      -DLINKED_12BIT=ON
    )
  '' + ''
    cmakeFlagsArray+=(
      -DGIT_ARCHETYPE=1 # https://bugs.gentoo.org/814116
      ${mkFlag (!stdenv.hostPlatform.isStatic) "ENABLE_SHARED"}
      -DHIGH_BIT_DEPTH=OFF
      -DENABLE_HDR10_PLUS=ON
      ${mkFlag (isCross && stdenv.hostPlatform.isAarch32) "CROSS_COMPILE_ARM"}
      ${mkFlag cliSupport "ENABLE_CLI"}
      ${mkFlag unittestsSupport "ENABLE_TESTS"}
    )
  '' + lib.optionalString isCross ''
    cmakeFlagsArray+=(
      ${mkFlag (isCross && stdenv.hostPlatform.isAarch64) "CROSS_COMPILE_ARM64"}
    )
  '';

  # Builds 10bits and 12bits static libs on the side if multi bit-depth is wanted
  # (we are in x265_<version>/source/build)
  preBuild = lib.optionalString multibitdepthSupport ''
    make -C ../build-10bits -j $NIX_BUILD_CORES
    make -C ../build-12bits -j $NIX_BUILD_CORES
    ln -s ../build-10bits/libx265.a ./libx265-10.a
    ln -s ../build-12bits/libx265.a ./libx265-12.a
  '';

  doCheck = unittestsSupport;
  checkPhase = ''
    runHook preCheck
    ./test/TestBench
    runHook postCheck
  '';

  postInstall = ''
    rm -f ${placeholder "out"}/lib/*.a
  ''
  # For mingw, libs are located in $out/bin not $out/lib
  + lib.optionalString stdenv.hostPlatform.isMinGW ''
    ln -s $out/bin/*.dll $out/lib
  '';

  meta = with lib; {
    description = "Library for encoding H.265/HEVC video streams";
    mainProgram = "x265";
    homepage = "https://www.x265.org/";
    changelog = "https://x265.readthedocs.io/en/master/releasenotes.html#version-${lib.strings.replaceStrings ["."] ["-"] version}";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ codyopel ];
    platforms = platforms.all;
  };
}
