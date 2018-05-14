{stdenv, fetchFromGitHub, autoconf, automake, libtool, gettext, autoreconfHook
, gmp, mpfr
}:
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "fplll";
  version = "5.2.0";
  src = fetchFromGitHub {
    owner = "${pname}";
    repo = "${pname}";
    rev = "${version}";
    sha256 = "0931i4q49lzlifsg9zd8a2yzj626i1s2bqhkfxvcxv94c38s0nh1";
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
