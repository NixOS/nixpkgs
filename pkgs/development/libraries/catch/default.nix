{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "catch-${version}";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "catchorg";
    repo = "Catch";
    rev = "v${version}";
    sha256 = "0v9yw7ydvhydp78hh7cmaif4h73k5qxqpm1g7xn8i882i3s84s2s";
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
