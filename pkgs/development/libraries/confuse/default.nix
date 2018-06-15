{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "confuse-${version}";
  version = "3.2.1";
  src = fetchurl {
    url = "https://github.com/martinh/libconfuse/releases/download/v${version}/${name}.tar.xz";
    sha256 = "0pnjmlj9i0alp407qd7c0vq83sz7gpsjrbdgpcn4xvzjp9r35ii3";
  };

  meta = {
    homepage = http://www.nongnu.org/confuse/;
    description = "Configuration file parser library";
    license = stdenv.lib.licenses.isc;
    platforms = stdenv.lib.platforms.unix;
  };
}
