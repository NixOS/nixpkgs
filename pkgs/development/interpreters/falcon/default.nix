{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, pcre, zlib, sqlite }:

stdenv.mkDerivation {
  pname = "falcon";
  version = "2013-09-19";

  src = fetchFromGitHub {
    owner = "falconpl";
    repo = "falcon";
    rev = "095141903c4ebab928ce803055f9bda363215c37";
    sha256 = "1x3gdcz1gqhi060ngqi0ghryf69v8bn50yrbzfad8bhblvhzzdlf";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ pcre zlib sqlite ];

  meta = with lib; {
    description = "Programming language with macros and syntax at once";
    license = licenses.gpl2;
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; linux;
  };
}
