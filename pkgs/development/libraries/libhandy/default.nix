{ stdenv
, fetchurl
, meson
, ninja
, pkgconfig
, gobject-introspection
, vala
, gtk-doc
, docbook_xsl
, docbook_xml_dtd_43
, gtk3
, gnome3
, glade
, dbus
, xvfb_run
, libxml2
, gdk-pixbuf
, librsvg
, hicolor-icon-theme
}:

stdenv.mkDerivation rec {
  pname = "libhandy";
  version = "1.0.0";

  outputs = [ "out" "dev" "devdoc" "glade" ];
  outputBin = "dev";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    hash = "sha256-qTmFgvR7fXKSBdbqwMBo/vNarySf3Vfuo3JPhRjSZpk=";
  };

  nativeBuildInputs = [
    docbook_xml_dtd_43
    docbook_xsl
    gobject-introspection
    gtk-doc
    libxml2
    meson
    ninja
    pkgconfig
    vala
  ];

  buildInputs = [
    gdk-pixbuf
    glade
    gtk3
    libxml2
  ];

  checkInputs = [
    dbus
    hicolor-icon-theme
    xvfb_run
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
  ];

  # Uses define_variable in pkgconfig, but we still need it to use the glade output
  PKG_CONFIG_GLADEUI_2_0_MODULEDIR = "${placeholder "glade"}/lib/glade/modules";
  PKG_CONFIG_GLADEUI_2_0_CATALOGDIR = "${placeholder "glade"}/share/glade/catalogs";

  # Bail out! dbind-FATAL-WARNING:
  # AT-SPI: Error retrieving accessibility bus address: org.freedesktop.DBus.Error.ServiceUnknown:
  # The name org.a11y.Bus was not provided by any .service files
  doCheck = false;

  checkPhase = ''
    NO_AT_BRIDGE=1 \
    XDG_DATA_DIRS="$XDG_DATA_DIRS:${hicolor-icon-theme}/share"
    GDK_PIXBUF_MODULE_FILE="${librsvg.out}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache" \
    xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
      --config-file=${dbus.daemon}/share/dbus-1/session.conf \
      meson test --print-errorlogs
  '';

  meta = with stdenv.lib; {
    changelog = "https://gitlab.gnome.org/GNOME/libhandy/-/tags/${version}";
    description = "Building blocks for modern adaptive GNOME apps";
    homepage = "https://gitlab.gnome.org/GNOME/libhandy";
    license = licenses.lgpl21Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
