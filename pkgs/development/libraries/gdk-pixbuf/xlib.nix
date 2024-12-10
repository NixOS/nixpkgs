{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  docbook-xsl-nons,
  docbook_xml_dtd_43,
  gtk-doc,
  gdk-pixbuf,
  libX11,
}:

stdenv.mkDerivation rec {
  pname = "gdk-pixbuf-xlib";
  version = "2.40.2";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "Archive";
    repo = "gdk-pixbuf-xlib";
    rev = version;
    hash = "sha256-b4EUaYzg2NlBMU90dGQivOvkv9KKSzES/ymPqzrelu8=";
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
