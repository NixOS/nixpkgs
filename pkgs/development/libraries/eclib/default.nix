{ lib, stdenv
, fetchFromGitHub
, autoreconfHook
, pari
, ntl
, gmp
# "FLINT is optional and only used for one part of sparse matrix reduction,
# which is used in the modular symbol code but not mwrank or other elliptic
# curve programs." -- https://github.com/JohnCremona/eclib/blob/master/README
, withFlint ? false, flint ? null
}:

assert withFlint -> flint != null;

stdenv.mkDerivation rec {
  pname = "eclib";
  version = "20190909"; # upgrade might break the sage interface
  # sage tests to run:
  # src/sage/interfaces/mwrank.py
  # src/sage/libs/eclib
  # ping @timokau for more info
  src = fetchFromGitHub {
    owner = "JohnCremona";
    repo = pname;
    rev = "v${version}";
    sha256 = "0y1vdi4120gdw56gg2dn3wh625yr9wpyk3wpbsd25w4lv83qq5da";
  };
  buildInputs = [
    pari
    ntl
    gmp
  ] ++ lib.optionals withFlint [
    flint
  ];
  nativeBuildInputs = [
    autoreconfHook
  ];
  doCheck = true;
  meta = with lib; {
    inherit version;
    description = "Elliptic curve tools";
    homepage = "https://github.com/JohnCremona/eclib";
    license = licenses.gpl2Plus;
    maintainers = teams.sage.members;
    platforms = platforms.all;
  };
}
