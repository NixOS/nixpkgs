{ stdenv
, fetchFromGitLab
, meson
, ninja
, pkg-config
, docbook-xsl-nons
, docbook_xml_dtd_43
, gtk-doc
, gdk-pixbuf
, libX11
}:

stdenv.mkDerivation rec {
  pname = "gdk-pixbuf-xlib";
  version = "2019-10-19-unstable";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "Archive";
    repo = "gdk-pixbuf-xlib";
    rev = "dc22ea36f69755007c66877284596df270532cc1";
    sha256 = "XhBQ4wano+MtGaqF6JNKoWgYQN6eBW+b8ZCGEBGt8IM=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    docbook-xsl-nons
    docbook_xml_dtd_43
    gtk-doc
  ];

  buildInputs = [
    libX11
  ];

  propagatedBuildInputs = [
    gdk-pixbuf
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
  ];

  meta = with stdenv.lib; {
    description = "Deprecated API for integrating GdkPixbuf with Xlib data types";
    homepage = "https://gitlab.gnome.org/Archive/gdk-pixbuf-xlib";
    maintainers = teams.gnome.members;
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
  };
}
