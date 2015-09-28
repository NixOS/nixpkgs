{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, librsvg, libxml2, intltool, itstool }:

stdenv.mkDerivation rec {
  name = "gnome-klotski-${gnome3.version}.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-klotski/${gnome3.version}/${name}.tar.xz";
    sha256 = "0a64935c7pp51jhaf29q9zlx3lamj7zrhyff7clvv0w8v1w6gpax";
  };

  buildInputs = [
    pkgconfig gtk3 wrapGAppsHook intltool itstool librsvg libxml2
    gnome3.defaultIconTheme
  ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Klotski;
    description = "Slide blocks to solve the puzzle";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
