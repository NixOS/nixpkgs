{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, librsvg, libcanberra-gtk3, intltool, itstool, libxml2, libgnome-games-support
, libgee}:

stdenv.mkDerivation rec {
  name = "gnome-robots-${version}";
  version = "3.31.3";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-robots/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1s9snyp1ga4sj2ajbspgx2b8d1icgb1xgjhx2cxxk1ls56db0cfb";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-robots"; attrPath = "gnome3.gnome-robots"; };
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    gtk3 wrapGAppsHook intltool itstool librsvg libcanberra-gtk3
    libxml2 gnome3.defaultIconTheme libgnome-games-support libgee
  ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Robots;
    description = "Avoid the robots and make them crash into each other";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
