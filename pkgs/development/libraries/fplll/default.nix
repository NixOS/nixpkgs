{ stdenv
, fetchFromGitHub
, autoconf
, automake
, libtool
, gettext
, autoreconfHook
, gmp
, mpfr
}:

stdenv.mkDerivation rec {
  pname = "fplll";
  version = "5.2.1";

  src = fetchFromGitHub {
    owner = "fplll";
    repo = "fplll";
    rev = version;
    sha256 = "015qmrd7nfaysbv1hbwiprz9g6hnww1y1z1xw8f43ysb7k1b5nbg";
  };

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    gettext
    autoreconfHook
  ];

  buildInputs = [
    gmp
    mpfr
  ];

  meta = with stdenv.lib; {
    description = ''Lattice algorithms using floating-point arithmetic'';
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [raskin];
    platforms = platforms.unix;
  };
}
