{ stdenv, fetchhg, cmake, yasm
, rev , sha256, version
, debugSupport ? false # Run-time sanity checks (debugging)
, highbitdepthSupport ? false # false=8bits per channel, true=10/12bits per channel
, werrorSupport ? false # Warnings as errors
, ppaSupport ? false # PPA profiling instrumentation
, vtuneSupport ? false # Vtune profiling instrumentation
, custatsSupport ? false # Internal profiling of encoder work
, cliSupport ? true # Build standalone CLI application
, unittestsSupport ? false # Unit tests
, ...
}:

let
  mkFlag = optSet: flag: if optSet then "-D${flag}=ON" else "-D${flag}=OFF";
in

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "x265-${version}";

  src = fetchhg {
    url = "https://bitbucket.org/multicoreware/x265/src";
    inherit rev;
    inherit sha256;
  };

  patchPhase = ''
    sed -i 's/unknown/${version}/g' source/cmake/version.cmake
  '';

  cmakeFlags = with stdenv.lib; [
    (mkFlag debugSupport "CHECKED_BUILD")
    "-DSTATIC_LINK_CRT=OFF"
    (mkFlag (highbitdepthSupport && stdenv.isx86_64) "HIGH_BIT_DEPTH")
    (mkFlag werrorSupport "WARNINGS_AS_ERRORS")
    (mkFlag ppaSupport "ENABLE_PPA")
    "-DENABLE_SHARED=ON"
    (mkFlag cliSupport "ENABLE_CLI")
    (mkFlag unittestsSupport "ENABLE_TESTS")
  ];

  preConfigure = ''
    cd source
  '';

  nativeBuildInputs = [ cmake yasm ];

  meta = {
    description = "Library for encoding h.265/HEVC video streams";
    homepage    = http://x265.org;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ codyopel ];
    platforms   = platforms.all;
  };
}