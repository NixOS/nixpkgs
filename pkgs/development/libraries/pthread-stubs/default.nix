{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libpthread-stubs-0.3";
  
  src = fetchurl {
    url = "http://xcb.freedesktop.org/dist/${name}.tar.bz2";
    sha256 = "0raxl73kmviqinp00bfa025d0j4vmfjjcvfn754mi60mw48swk80";
  };

  meta = {
    homepage = http://xcb.freedesktop.org/;
    license = "bsd";
  };
}
