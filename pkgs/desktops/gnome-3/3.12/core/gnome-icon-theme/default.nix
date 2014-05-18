{ stdenv, fetchurl, pkgconfig, intltool, iconnamingutils, gtk }:

stdenv.mkDerivation rec {
  name = "gnome-icon-theme-3.12.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-icon-theme/3.12/${name}.tar.xz";
    sha256 = "359e720b9202d3aba8d477752c4cd11eced368182281d51ffd64c8572b4e503a";
  };

  setupHook = ./setup-hook.sh;

  nativeBuildInputs = [ pkgconfig intltool iconnamingutils gtk ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}
