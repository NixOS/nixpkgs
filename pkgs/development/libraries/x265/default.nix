{ stdenv, fetchurl, fetchpatch, cmake, nasm, numactl
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
  ];

  version = "3.2";

  src = fetchurl {
    urls = [
      "https://get.videolan.org/x265/x265_${version}.tar.gz"
      "ftp://ftp.videolan.org/pub/videolan/x265/x265_${version}.tar.gz"
    ];
    sha256 = "0fqkhfhr22gzavxn60cpnj3agwdf5afivszxf3haj5k1sny7jk9n";
  };

  patches = [
    # Fix build on ARM (#406)
    (fetchpatch {
      url = "https://bitbucket.org/multicoreware/x265_git/issues/attachments/406/multicoreware/x265_git/1599791236.73/406/X265-2.8-asm-primitives.patch";
      sha256 = "1vf8bpl37gbd9dcbassgkq9i0rp24qm3bl6hx9zv325174bn402v";
    })
  ];

  buildLib = has12Bit: stdenv.mkDerivation rec {
    name = "libx265-${if has12Bit then "12" else "10"}-${version}";
    inherit src patches;
    enableParallelBuilding = true;

    postPatch = ''
      sed -i 's/unknown/${version}/g' source/cmake/version.cmake
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

    nativeBuildInputs = [cmake nasm] ++ stdenv.lib.optional numaSupport numactl;
  };

  libx265-10 = buildLib false;
  libx265-12 = buildLib true;
in

stdenv.mkDerivation rec {
  pname = "x265";
  inherit version src patches;

  enableParallelBuilding = true;

  postPatch = ''
    sed -i 's/unknown/${version}/g' source/cmake/version.cmake
  '';

  cmakeFlags = [
    "-DENABLE_SHARED=ON"
    "-DHIGH_BIT_DEPTH=OFF"
    "-DENABLE_HDR10_PLUS=OFF"
  ] ++ stdenv.lib.optionals is64bit [
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

  nativeBuildInputs = [ cmake nasm ] ++ stdenv.lib.optional numaSupport numactl;

  meta = with stdenv.lib; {
    description = "Library for encoding h.265/HEVC video streams";
    homepage    = "http://x265.org";
    license     = licenses.gpl2;
    maintainers = with maintainers; [ codyopel ];
    platforms   = platforms.all;
  };
}
