{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, librsvg, libcanberra_gtk3, intltool, itstool, libxml2 }:

stdenv.mkDerivation rec {
  name = "gnome-robots-${gnome3.version}.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-robots/${gnome3.version}/${name}.tar.xz";
    sha256 = "0dhzl1rhn4ysp3s3j0lxsiw64acz0w1n1bljrfln9s07x8nj17nx";
  };

  buildInputs = [
    pkgconfig gtk3 wrapGAppsHook intltool itstool librsvg libcanberra_gtk3
    libxml2 gnome3.defaultIconTheme
  ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Robots;
    description = "Avoid the robots and make them crash into each other";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
