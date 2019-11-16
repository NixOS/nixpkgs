{ stdenv
, fetchurl
, fetchpatch
, meson
, ninja
, pkgconfig
, gtk-doc
, docbook_xsl
, docbook_xml_dtd_412
, libX11
, glib
, gtk3
, pango
, cairo
, libXres
, libstartup_notification
, gettext
, gobject-introspection
, gnome3
}:

stdenv.mkDerivation rec{
  pname = "libwnck";
  version = "3.32.0";

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "dev";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1jp3p1lnwnwi6fxl2rz3166cmwzwy9vqz896anpwc3wdy9f875cm";
  };

  patches = [
    # https://gitlab.gnome.org/GNOME/libwnck/issues/139
    (fetchpatch {
      url = https://gitlab.gnome.org/GNOME/libwnck/commit/0d9ff7db63af568feef8e8c566e249058ccfcb4e.patch;
      sha256 = "18f78aayq9jma54v2qz3rm2clmz1cfq5bngxw8p4zba7hplyqsl9";
    })
    # https://gitlab.gnome.org/GNOME/libwnck/merge_requests/12
    ./fix-pc-file.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    gettext
    gobject-introspection
    gtk-doc
    docbook_xsl
    docbook_xml_dtd_412
  ];

  buildInputs = [
    libX11
    libstartup_notification
    pango
    cairo
    libXres
  ];

  propagatedBuildInputs = [
    glib
    gtk3
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "${pname}${stdenv.lib.versions.major version}";
    };
  };

  meta = with stdenv.lib; {
    description = "Library to manage X windows and workspaces (via pagers, tasklists, etc.)";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.worldofpeace ];
  };
}
