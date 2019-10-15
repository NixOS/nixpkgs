{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "catch2";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "catchorg";
    repo = "Catch2";
    rev = "v${version}";
    sha256="1i7nz29gcsy9cnljb0sb1fw8fg9p1gdh2pdhrgj3kcrsnxgbyhrq";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-H.." ];

  meta = with stdenv.lib; {
    description = "A multi-paradigm automated test framework for C++ and Objective-C (and, maybe, C)";
    homepage = http://catch-lib.net;
    license = licenses.boost;
    maintainers = with maintainers; [ edwtjo knedlsepp ];
    platforms = with platforms; unix;
  };
}
