{ lib, mkDerivation, fetchFromGitHub, cmake,
  qtbase, cfitsio, gsl, wcslib, withTester ? false }:

mkDerivation rec {
  pname = "stellarsolver";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "rlancaste";
    repo = pname;
    rev = version;
    sha256 = "12j20j9qbkkx55ix4nm1iw7wd36hamkpidbwhcnmj4yk5fqlyq4y";
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
    platforms = platforms.linux;
  };
}
