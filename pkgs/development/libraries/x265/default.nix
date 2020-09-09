{ stdenv, fetchFromGitHub, cmake, nasm, numactl
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
  version = "3.4";

  src = fetchFromGitHub {
            owner  = "videolan";
            repo   = "x265";
            rev    = "${version}";
            sha256 = "048c906xpp3m12m2xnb6zf2y39milxajp2n0kffa41pdya3zqn95";
        };

  enableParallelBuilding = true;

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
