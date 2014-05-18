{ stdenv, fetchurl, pkgconfig, intltool, iconnamingutils, gtk }:

stdenv.mkDerivation rec {
  name = "gnome-icon-theme-3.10.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-icon-theme/3.10/${name}.tar.xz";
    sha256 = "1xinbgkkvlhazj887ajcl13i7kdc1wcca02jwxzvjrvchjsp4m66";
  };

  setupHook = ./setup-hook.sh;

  nativeBuildInputs = [ pkgconfig intltool iconnamingutils gtk ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}
