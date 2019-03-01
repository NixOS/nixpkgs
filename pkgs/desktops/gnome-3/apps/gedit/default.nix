{ stdenv, intltool, fetchurl
, pkgconfig, gtk3, glib, adwaita-icon-theme
, libpeas, gtksourceview, gsettings-desktop-schemas
, wrapGAppsHook, itstool, libsoup, libxml2
, gnome3, gspell }:

stdenv.mkDerivation rec {
  name = "gedit-${version}";
  version = "3.30.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gedit/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0qwig35hzvjaqic9x92jcpmycnvcybsbnbiw6rppryx0arwb3wza";
  };

  nativeBuildInputs = [ pkgconfig wrapGAppsHook intltool itstool libxml2 ];

  buildInputs = [
    gtk3 glib
    adwaita-icon-theme libsoup
    libpeas gtksourceview
    gsettings-desktop-schemas gspell
  ];

  enableParallelBuilding = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gedit";
      attrPath = "gnome3.gedit";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Gedit;
    description = "Official text editor of the GNOME desktop environment";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
