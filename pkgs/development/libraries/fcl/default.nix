{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, eigen, libccd, octomap }:

stdenv.mkDerivation rec {
  pname = "fcl";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "flexible-collision-library";
    repo = pname;
    rev = version;
    sha256 = "1i1sd0fsvk5d529aw8aw29bsmymqgcmj3ci35sz58nzp2wjn0l5d";
  };

  patches = [
    # Disable SSE on Emscripten (required for the next patch to apply cleanly)
    # https://github.com/flexible-collision-library/fcl/pull/470
    (fetchpatch {
      url = "https://github.com/flexible-collision-library/fcl/commit/83a1af61ba4efa81ec0b552b3121100044a8cf46.patch";
      sha256 = "0bbkv4xpkl3c0i8qdlkghj6qkybrrd491c8rd2cqnxfgspcd40p0";
    })
    # Detect SSE support to fix building on ARM
    # https://github.com/flexible-collision-library/fcl/pull/506
    (fetchpatch {
      url = "https://github.com/flexible-collision-library/fcl/commit/cbfe1e9405aa68138ed1a8f33736429b85500dea.patch";
      sha256 = "18qip8gwhm3fvbz1cvzf625rh5msq8m4669ld1m60fv6z50clr9h";
    })
  ];

  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [ eigen libccd octomap ];

  outputs = [ "out" "dev" ];

  meta = with lib; {
    description = "Flexible Collision Library";
    longDescription = ''
      FCL is a library for performing three types of proximity queries on a
      pair of geometric models composed of triangles.
    '';
    homepage = "https://github.com/flexible-collision-library/fcl";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lopsided98 ];
    platforms = platforms.unix;
  };
}
