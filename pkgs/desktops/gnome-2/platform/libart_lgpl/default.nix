{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "libart_lgpl-2.3.21";
  src = fetchurl {
    url = "mirror://gnome/sources/libart_lgpl/2.3/${name}.tar.bz2";
    sha256 = "1yknfkyzgz9s616is0l9gp5aray0f2ry4dw533jgzj8gq5s1xhgx";
  };
}
