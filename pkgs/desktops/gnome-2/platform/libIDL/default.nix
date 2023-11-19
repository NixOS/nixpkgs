{ lib, stdenv, fetchurl, flex, bison, pkg-config, glib, gettext }:

stdenv.mkDerivation rec {
  pname = "libIDL";
  version = "0.8.14";

  src = fetchurl {
    url = "mirror://gnome/sources/libIDL/${lib.versions.majorMinor version}/libIDL-${version}.tar.bz2";
    sha256 = "08129my8s9fbrk0vqvnmx6ph4nid744g5vbwphzkaik51664vln5";
  };

  buildInputs = [ glib gettext ];

  nativeBuildInputs = [ flex bison pkg-config ];
}
