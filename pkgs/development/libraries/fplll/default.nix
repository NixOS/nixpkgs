{stdenv, fetchFromGitHub, autoconf, automake, libtool, gettext, autoreconfHook
, gmp, mpfr
}:
stdenv.mkDerivation rec {
  pname = "fplll";
  version = "5.2.1";
  src = fetchFromGitHub {
    owner = "${pname}";
    repo = "${pname}";
    rev = "${version}";
    sha256 = "015qmrd7nfaysbv1hbwiprz9g6hnww1y1z1xw8f43ysb7k1b5nbg";
  };
  nativeBuildInputs = [autoconf automake libtool gettext autoreconfHook];
  buildInputs = [gmp mpfr];
  meta = {
    inherit version;
    description = ''Lattice algorithms using floating-point arithmetic'';
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
