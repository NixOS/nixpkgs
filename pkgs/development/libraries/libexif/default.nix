{ stdenv, fetchurl, gettext }:

stdenv.mkDerivation rec {
  name = "libexif-0.6.16";

  src = fetchurl {
    url = "mirror://sourceforge/libexif/${name}.tar.bz2";
    sha256 = "0hxc3aik3sn8xq4mbmxxb8ycx2lwffmhi5xvz0zjffhfwkaqas6v";
  };

  buildInputs = [ gettext ];
}
