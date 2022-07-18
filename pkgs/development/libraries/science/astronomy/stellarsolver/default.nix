{ lib, mkDerivation, fetchFromGitHub, cmake,
  qtbase, cfitsio, gsl, wcslib, withTester ? false }:

mkDerivation rec {
  pname = "stellarsolver";
  version = "2.3";

  src = fetchFromGitHub {
    owner = "rlancaste";
    repo = pname;
    rev = version;
    sha256 = "sha256-DSydgn9brVQlVNfW8Lnw/ZNs7aftokkCuJshgqmegpY=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ qtbase cfitsio gsl wcslib ];

  cmakeFlags = [
    "-DBUILD_TESTER=${if withTester then "on" else "off"}"
  ];

  meta = with lib; {
    homepage = "https://github.com/rlancaste/stellarsolver";
    description = "Astrometric plate solving library";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ hjones2199 ];
    platforms = platforms.unix;
  };
}
