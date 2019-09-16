{ stdenv, fetchFromGitHub, cmake }:

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

  doCheck = true;
  checkTarget = "test";

  meta = with stdenv.lib; {
    description = "A multi-paradigm automated test framework for C++ and Objective-C (and, maybe, C)";
    homepage = http://catch-lib.net;
    license = licenses.boost;
    maintainers = with maintainers; [ edwtjo knedlsepp ];
    platforms = with platforms; unix;
  };
}
