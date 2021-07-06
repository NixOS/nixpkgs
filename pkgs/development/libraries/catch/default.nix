{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake }:

stdenv.mkDerivation rec {
  pname = "catch";
  version = "1.12.2";

  src = fetchFromGitHub {
    owner = "catchorg";
    repo = "Catch";
    rev = "v${version}";
    sha256 = "1gdp5wm8khn02g2miz381llw3191k7309qj8s3jd6sasj01rhf23";
  };

  nativeBuildInputs = [ cmake ];
  cmakeFlags = [ "-DUSE_CPP14=ON" ];

  patches = [
    # https://github.com/catchorg/Catch2/pull/2151
    (fetchpatch {
      url = "https://github.com/catchorg/Catch2/commit/bb6d08323f23a39eb65dd86671e68f4f5d3f2d6c.patch";
      sha256 = "1vhbzx84nrhhf9zlbl6h5zmg3r5w5v833ihlswsysb9wp2i4isc5";
    })
  ];

  doCheck = true;
  checkTarget = "test";

  meta = with lib; {
    description = "A multi-paradigm automated test framework for C++ and Objective-C (and, maybe, C)";
    homepage = "http://catch-lib.net";
    license = licenses.boost;
    maintainers = with maintainers; [ edwtjo knedlsepp ];
    platforms = with platforms; unix;
  };
}
