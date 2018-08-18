{ stdenv, meson, ninja, gettext, fetchurl, evince, gjs
, pkgconfig, gtk3, glib, tracker, tracker-miners
, itstool, libxslt, webkitgtk, libgdata
, gnome-desktop, libzapojit, libgepub
, gnome3, gdk_pixbuf, libsoup, docbook_xsl
, gobjectIntrospection, inkscape, poppler_utils
, desktop-file-utils, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "gnome-documents-${version}";
  version = "3.28.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-documents/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "1i0s246bg9xcjxgbajph744pn65bq5gk6r9kkl3f5iwdq3rjc0pm";
  };

  doCheck = true;

  mesonFlags = [ "-Dgetting-started=true" ];

  nativeBuildInputs = [
    meson ninja pkgconfig gettext itstool libxslt desktop-file-utils docbook_xsl wrapGAppsHook
    inkscape poppler_utils # building getting started
  ];
  buildInputs = [
    gtk3 glib gnome3.gsettings-desktop-schemas
    gdk_pixbuf gnome3.defaultIconTheme evince
    libsoup webkitgtk gjs gobjectIntrospection
    tracker tracker-miners libgdata
    gnome-desktop libzapojit libgepub
  ];

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py
  '';

  preFixup = ''
    substituteInPlace $out/bin/gnome-documents --replace gapplication "${glib.dev}/bin/gapplication"
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gnome-documents";
      attrPath = "gnome3.gnome-documents";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Documents;
    description = "Document manager application designed to work with GNOME 3";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
