{ lib, stdenv
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
  version = "2020-06-11-unstable";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "Archive";
    repo = "gdk-pixbuf-xlib";
    rev = "3116b8ae55501cf48d16970aa2b50a5530e15223";
    sha256 = "15wisf2xld3cr7lprnic8fvwpcmww4rydwc1bn2zilyi52vzl2zd";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    docbook-xsl-nons
    docbook_xml_dtd_43
    gtk-doc
  ];

  propagatedBuildInputs = [
    gdk-pixbuf
    libX11
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
  ];

  meta = with lib; {
    description = "Deprecated API for integrating GdkPixbuf with Xlib data types";
    homepage = "https://gitlab.gnome.org/Archive/gdk-pixbuf-xlib";
    maintainers = teams.gnome.members;
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
  };
}
