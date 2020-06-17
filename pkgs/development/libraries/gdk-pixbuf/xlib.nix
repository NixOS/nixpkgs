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
    rev = "19482794a621d542b223219940e836257d4ae2c9";
    sha256 = "7Qv6tyjR0/iFXYHx5jPhvLLLt0Ms2nzpyWw02oXTkZc=";
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

  meta = with stdenv.lib; {
    description = "Deprecated API for integrating GdkPixbuf with Xlib data types";
    homepage = "https://gitlab.gnome.org/Archive/gdk-pixbuf-xlib";
    maintainers = teams.gnome.members;
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
  };
}
