{ stdenv, fetchFromGitHub, cmake, python }:

stdenv.mkDerivation rec {
  name = "catch2-${version}";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "catchorg";
    repo = "Catch2";
    rev = "v${version}";
    sha256="0pmkqx5b3vy2ppz0h3ijd8v1387yfgykpw2kz0zzwr9mdv9adw7a";
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
