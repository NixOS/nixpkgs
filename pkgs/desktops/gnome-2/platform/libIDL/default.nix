{stdenv, fetchurl_gnome, flex, bison, pkgconfig, glib, gettext}:

stdenv.mkDerivation rec {
  name = src.pkgname;

  src = fetchurl_gnome {
    project = "libIDL";
    major = "0"; minor = "8"; patchlevel = "14";
    sha256 = "08129my8s9fbrk0vqvnmx6ph4nid744g5vbwphzkaik51664vln5";
  };

  buildInputs = [ glib gettext ];

  nativeBuildInputs = [ flex bison pkgconfig ];
}
