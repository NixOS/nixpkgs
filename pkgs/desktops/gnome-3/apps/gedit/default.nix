{ stdenv, intltool, fetchurl, enchant, isocodes
, pkgconfig, gtk3, glib
, bash, wrapGAppsHook, itstool, libsoup, libxml2
, gnome3, librsvg, gdk_pixbuf, file, gspell }:

stdenv.mkDerivation rec {
  name = "gedit-${version}";
  version = "3.28.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gedit/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0pyam0zi44xq776x20ycqnvmf86l98jns8ldv4m81gnp9wnhmycv";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gedit"; attrPath = "gnome3.gedit"; };
  };

  propagatedUserEnvPkgs = [ gnome3.gnome-themes-standard ];

  nativeBuildInputs = [ pkgconfig wrapGAppsHook ];

  buildInputs = [ gtk3 glib intltool itstool enchant isocodes
                  gdk_pixbuf gnome3.defaultIconTheme librsvg libsoup
                  gnome3.libpeas gnome3.gtksourceview libxml2
                  gnome3.gsettings-desktop-schemas gnome3.dconf file gspell ];

  enableParallelBuilding = true;

  preFixup = ''
    gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath [ gnome3.libpeas gnome3.gtksourceview ]}")
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Gedit;
    description = "Official text editor of the GNOME desktop environment";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
