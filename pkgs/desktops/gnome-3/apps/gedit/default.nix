{ stdenv, intltool, fetchurl
, pkgconfig, gtk3, glib
, wrapGAppsHook, itstool, libsoup, libxml2
, gnome3, gspell }:

stdenv.mkDerivation rec {
  name = "gedit-${version}";
  version = "3.28.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gedit/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0791r07d3ixmmfk68lvhp3d5i4vnlrnx10csxwgpfqyfb04vwx7i";
  };

  nativeBuildInputs = [ pkgconfig wrapGAppsHook intltool itstool libxml2 ];

  buildInputs = [
    gtk3 glib
    gnome3.defaultIconTheme libsoup
    gnome3.libpeas gnome3.gtksourceview
    gnome3.gsettings-desktop-schemas gspell
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
