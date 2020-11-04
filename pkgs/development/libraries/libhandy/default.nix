{ stdenv, fetchFromGitLab, fetchpatch, meson, ninja, pkgconfig, gobject-introspection, vala
, gtk-doc, docbook_xsl, docbook_xml_dtd_43
, gtk3, gnome3, glade, librsvg
, dbus, xvfb_run, libxml2
, hicolor-icon-theme
}:

stdenv.mkDerivation rec {
  pname = "libhandy";
  version = "1.0.1";

  outputs = [ "out" "dev" "devdoc" "glade" ];
  outputBin = "dev";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = pname;
    rev = "5cee0927b8b39dea1b2a62ec6d19169f73ba06c6";
    sha256 = "1ah46fap05ix2vakv9f0cd1chcjmas3jbjg2a9jzqch763rwwgia";
  };

  nativeBuildInputs = [
    meson ninja pkgconfig gobject-introspection vala libxml2
    gtk-doc docbook_xsl docbook_xml_dtd_43
  ];
  buildInputs = [ gnome3.gnome-desktop gtk3 glade libxml2 librsvg ];
  checkInputs = [ dbus xvfb_run hicolor-icon-theme ];

  mesonFlags = [
    "-Dgtk_doc=true"
    "-Dglade_catalog=enabled"
    "-Dintrospection=enabled"
  ];

  PKG_CONFIG_GLADEUI_2_0_MODULEDIR = "${placeholder "glade"}/lib/glade/modules";
  PKG_CONFIG_GLADEUI_2_0_CATALOGDIR = "${placeholder "glade"}/share/glade/catalogs";

  doCheck = true;

  checkPhase = ''
    NO_AT_BRIDGE=1 \
    XDG_DATA_DIRS="$XDG_DATA_DIRS:${hicolor-icon-theme}/share" \
    xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
      --config-file=${dbus.daemon}/share/dbus-1/session.conf \
      meson test --print-errorlogs
  '';

  meta = with stdenv.lib; {
    description = "A library full of GTK widgets for mobile phones";
    homepage = "https://gitlab.gnome.org/GNOME/libhandy";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
}
