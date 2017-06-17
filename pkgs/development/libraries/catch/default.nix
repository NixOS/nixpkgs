{ stdenv, cmake, fetchFromGitHub }:

stdenv.mkDerivation rec {

  name = "catch-${version}";
  version = "1.9.5";

  src = fetchFromGitHub {
    owner = "philsquared";
    repo = "Catch";
    rev = "v${version}";
    sha256 = "1in4f6w1pja8m1hvyiwx7s7gxnj6nlj1fgxw9blldffh09ikgpm2";
  };

  nativeBuildInputs = [ cmake ];
  cmakeFlags = [ "-DUSE_CPP14=ON" ];

  doCheck = true;
  checkTarget = "test";

  meta = with stdenv.lib; {
    description = "A multi-paradigm automated test framework for C++ and Objective-C (and, maybe, C)";
    homepage = "http://catch-lib.net";
    license = licenses.boost;
    maintainers = with maintainers; [ edwtjo knedlsepp ];
    platforms = with platforms; unix;
  };
}
