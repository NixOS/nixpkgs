{ stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, gtk-doc
, docbook-xsl-nons
, docbook_xml_dtd_43
, wayland
, gtk3
, gobject-introspection
}:

stdenv.mkDerivation rec {
  pname = "gtk-layer-shell";
  version = "0.3.0";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchFromGitHub {
    owner = "wmww";
    repo = "gtk-layer-shell";
    rev = "v${version}";
    sha256 = "1f7hfwik7a9kzw0q1k3xc1yisrgg8lbp5pjr337phc9hm38lhq3c";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_43
  ];

  buildInputs = [
    wayland
    gtk3
  ];

  mesonFlags = [
    "-Ddocs=true"
  ];

  meta = with stdenv.lib; {
    description = "A library to create panels and other desktop components for Wayland using the Layer Shell protocol";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ eonpatapon ];
    platforms = platforms.unix;
  };
}
