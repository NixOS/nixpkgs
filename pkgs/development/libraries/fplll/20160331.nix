{stdenv, fetchFromGitHub, autoconf, automake, libtool, gettext, autoreconfHook
, gmp, mpfr
}:
stdenv.mkDerivation rec {
  pname = "fplll";
  version = "20160331";
  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "11dea26c2f9396ffb7a7191aa371343f1f74c5c3";
    sha256 = "1clxch9hbr30w6s84m2mprxv58adhg5qw6sa2p3jr1cy4r7r59ib";
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
