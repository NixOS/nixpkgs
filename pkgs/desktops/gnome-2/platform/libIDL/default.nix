{stdenv, fetchurl, flex, bison, pkgconfig, glib, gettext}:

stdenv.mkDerivation rec {
  name = "libIDL-${minVer}.14";
  minVer = "0.8";

  src = fetchurl {
    url = "mirror://gnome/sources/libIDL/${minVer}/${name}.tar.bz2";
    sha256 = "08129my8s9fbrk0vqvnmx6ph4nid744g5vbwphzkaik51664vln5";
  };

  buildInputs = [ glib gettext ];

  nativeBuildInputs = [ flex bison pkgconfig ];
}
