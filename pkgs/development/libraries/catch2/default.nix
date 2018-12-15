{ stdenv, fetchFromGitHub, cmake, python }:

stdenv.mkDerivation rec {
  name = "catch2-${version}";
  version = "2.4.2";

  src = fetchFromGitHub {
    owner = "catchorg";
    repo = "Catch2";
    rev = "v${version}";
    sha256="1105bxbvh1xxl4yxjjp6l6w6hgsh8xbdiwlnga9di5y2x92b9bjd";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-H.."
    "-DBUILD_TESTING=OFF"];

  meta = with stdenv.lib; {
    description = "A multi-paradigm automated test framework for C++ and Objective-C (and, maybe, C)";
    homepage = http://catch-lib.net;
    license = licenses.boost;
    maintainers = with maintainers; [ edwtjo knedlsepp ];
    platforms = with platforms; unix;
  };
}
