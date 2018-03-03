{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, librsvg, libcanberra-gtk3, intltool, itstool, libxml2, libgames-support
, libgee}:

stdenv.mkDerivation rec {
  name = "gnome-robots-${version}";
  version = "3.22.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-robots/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "c5d63f0fcae66d0df9b10e39387d09875555909f0aa7e57ef8552621d852082f";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-robots"; attrPath = "gnome3.gnome-robots"; };
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    gtk3 wrapGAppsHook intltool itstool librsvg libcanberra-gtk3
    libxml2 gnome3.defaultIconTheme libgames-support libgee
  ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Robots;
    description = "Avoid the robots and make them crash into each other";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
