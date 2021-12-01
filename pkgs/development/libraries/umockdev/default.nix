{ stdenv
, lib
, docbook-xsl-nons
, fetchurl
, glib
, gobject-introspection
, gtk-doc
, libgudev
, libpcap
, meson
, ninja
, pkg-config
, python3
, systemd
, usbutils
, vala
, which
}:

stdenv.mkDerivation rec {
  pname = "umockdev";
  version = "0.16.3";

  outputs = [ "bin" "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "https://github.com/martinpitt/umockdev/releases/download/${version}/${pname}-${version}.tar.xz";
    sha256 = "TjHxqtz8mPhzpsMb5lXWdj8hx/whsadTfor4S2x4U2M=";
  };

  nativeBuildInputs = [
    docbook-xsl-nons
    gobject-introspection
    gtk-doc
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    glib
    systemd
    libgudev
    libpcap
  ];

  checkInputs = [
    python3
    which
    usbutils
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
  ];

  doCheck = true;

  meta = with lib; {
    description = "Mock hardware devices for creating unit tests";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ flokli ];
    platforms = with platforms; linux;
  };
}
