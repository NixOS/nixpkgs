{stdenv, fetchFromGitHub, autoconf, automake, libtool, gettext, autoreconfHook
, gmp, mpfr
}:
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "fplll";
  version = "5.0.2";
  src = fetchFromGitHub {
    owner = "${pname}";
    repo = "${pname}";
    rev = "${version}";
    sha256 = "0rl98rx284giyhj3pf6iydn1a06jis8c8mnsc7kqs4rcmiw4bjpx";
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
