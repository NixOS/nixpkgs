{ lib, stdenv, fetchFromBitbucket, cmake, nasm, numactl
, numaSupport ? stdenv.hostPlatform.isLinux && (stdenv.hostPlatform.isx86 || stdenv.hostPlatform.isAarch64)  # Enabled by default on NUMA platforms
, debugSupport ? false # Run-time sanity checks (debugging)
, werrorSupport ? false # Warnings as errors
, ppaSupport ? false # PPA profiling instrumentation
, vtuneSupport ? false # Vtune profiling instrumentation
, custatsSupport ? false # Internal profiling of encoder work
, cliSupport ? true # Build standalone CLI application
, unittestsSupport ? false # Unit tests
}:

let
  mkFlag = optSet: flag: if optSet then "-D${flag}=ON" else "-D${flag}=OFF";
  inherit (stdenv) is64bit;

  cmakeFlagsAll = [
    "-DSTATIC_LINK_CRT=OFF"
    (mkFlag debugSupport "CHECKED_BUILD")
    (mkFlag ppaSupport "ENABLE_PPA")
    (mkFlag vtuneSupport "ENABLE_VTUNE")
    (mkFlag custatsSupport "DETAILED_CU_STATS")
    (mkFlag unittestsSupport "ENABLE_TESTS")
    (mkFlag werrorSupport "WARNINGS_AS_ERRORS")
  ] ++ lib.optionals stdenv.hostPlatform.isPower [
    "-DENABLE_ALTIVEC=OFF"
  ];

  version = "3.4";

  src = fetchFromBitbucket {
    owner = "multicoreware";
    repo = "x265_git";
    rev = version;
    sha256 = "1jzgv2hxhcwmsdf6sbgyzm88a46dp09ll1fqj92g9vckvh9a7dsn";
  };

  buildLib = has12Bit: stdenv.mkDerivation rec {
    name = "libx265-${if has12Bit then "12" else "10"}-${version}";
    inherit src;

    postPatch = ''
      sed -i 's/unknown/${version}/g' source/cmake/version.cmake
      sed -i 's/0.0/${version}/g' source/cmake/version.cmake
    '';

    cmakeLibFlags = [
      "-DENABLE_CLI=OFF"
      "-DENABLE_SHARED=OFF"
      "-DENABLE_HDR10_PLUS=ON"
      "-DEXPORT_C_API=OFF"
      "-DHIGH_BIT_DEPTH=ON"
    ];
    cmakeFlags = [(mkFlag has12Bit "MAIN12")] ++ cmakeLibFlags ++ cmakeFlagsAll;

    preConfigure = ''
      cd source
    '';

    nativeBuildInputs = [cmake nasm] ++ lib.optional numaSupport numactl;
  };

  libx265-10 = buildLib false;
  libx265-12 = buildLib true;
in

stdenv.mkDerivation rec {
  pname = "x265";
  inherit version src;

  postPatch = ''
    sed -i 's/unknown/${version}/g' source/cmake/version.cmake
    sed -i 's/0.0/${version}/g' source/cmake/version.cmake
  '';

  cmakeFlags = [
    "-DENABLE_SHARED=ON"
    "-DHIGH_BIT_DEPTH=OFF"
    "-DENABLE_HDR10_PLUS=OFF"
  ] ++ lib.optionals (is64bit && !(stdenv.isAarch64 && stdenv.isLinux)) [
    "-DEXTRA_LIB=${libx265-10}/lib/libx265.a;${libx265-12}/lib/libx265.a"
    "-DLINKED_10BIT=ON"
    "-DLINKED_12BIT=ON"
  ] ++ [
    (mkFlag cliSupport "ENABLE_CLI")
  ] ++ cmakeFlagsAll;

  preConfigure = ''
    cd source
  '';

  postInstall = ''
    rm $out/lib/*.a
  '';

  nativeBuildInputs = [ cmake nasm ] ++ lib.optional numaSupport numactl;

  meta = with lib; {
    description = "Library for encoding h.265/HEVC video streams";
    homepage    = "http://x265.org";
    license     = licenses.gpl2;
    maintainers = with maintainers; [ codyopel ];
    platforms   = platforms.all;
  };
}
