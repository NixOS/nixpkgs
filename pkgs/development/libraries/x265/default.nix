{ stdenv, fetchurl, fetchpatch, cmake, nasm, numactl
, numaSupport ? stdenv.hostPlatform.isLinux && (stdenv.hostPlatform.isx86 || stdenv.hostPlatform.isAarch64)  # Enabled by default on NUMA platforms
, debugSupport ? false # Run-time sanity checks (debugging)
, highbitdepthSupport ? false # false=8bits per channel, true=10/12bits per channel
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
in

stdenv.mkDerivation rec {
  pname = "x265";
  version = "3.1.1";

  src = fetchurl {
    urls = [
      "https://get.videolan.org/x265/x265_${version}.tar.gz"
      "ftp://ftp.videolan.org/pub/videolan/x265/x265_${version}.tar.gz"
    ];
    sha256 = "1l68lgdbsi4wjz5vad98ggx7mf92rnvzlq34m6w0a08ark3h0yc2";
  };

  enableParallelBuilding = true;

  patches = [
    # Fix build on ARM (#406)
    (fetchpatch {
      url = "https://bitbucket.org/multicoreware/x265/issues/attachments/406/multicoreware/x265/1527562952.26/406/X265-2.8-asm-primitives.patch";
      sha256 = "1vf8bpl37gbd9dcbassgkq9i0rp24qm3bl6hx9zv325174bn402v";
    })
  ];

  postPatch = ''
    sed -i 's/unknown/${version}/g' source/cmake/version.cmake
  '';

  cmakeFlags = [
    (mkFlag debugSupport "CHECKED_BUILD")
    "-DSTATIC_LINK_CRT=OFF"
    (mkFlag (highbitdepthSupport && is64bit) "HIGH_BIT_DEPTH")
    (mkFlag werrorSupport "WARNINGS_AS_ERRORS")
    (mkFlag ppaSupport "ENABLE_PPA")
    (mkFlag vtuneSupport "ENABLE_VTUNE")
    (mkFlag custatsSupport "DETAILED_CU_STATS")
    "-DENABLE_SHARED=ON"
    (mkFlag cliSupport "ENABLE_CLI")
    (mkFlag unittestsSupport "ENABLE_TESTS")
  ];

  preConfigure = ''
    cd source
  '';

  postInstall = ''
    rm $out/lib/*.a
  '';

  nativeBuildInputs = [ cmake nasm ] ++ stdenv.lib.optional numaSupport numactl;

  meta = with stdenv.lib; {
    description = "Library for encoding h.265/HEVC video streams";
    homepage    = http://x265.org;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ codyopel ];
    platforms   = platforms.all;
  };
}
