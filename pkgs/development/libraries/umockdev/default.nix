{ lib, stdenv
, docbook_xsl
, fetchurl
, glib
, gobject-introspection
, gtk-doc
, libgudev
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
  version = "0.15.4";

  outputs = [ "bin" "out" "dev" "doc" ];

  src = fetchurl {
    url = "https://github.com/martinpitt/umockdev/releases/download/${version}/${pname}-${version}.tar.xz";
    sha256 = "09k8jwvsphd97hcagf0zaf0hwzlzq2r8jfgbmvj55k7ylrg8hjxg";
  };

  mesonFlags = [
    "-Dgtk_doc=true"
  ];

  buildInputs = [ glib systemd libgudev ];

  nativeBuildInputs = [
    docbook_xsl
    gobject-introspection
    gtk-doc
    meson
    ninja
    pkg-config
    vala
  ];

  checkInputs = [ python3 which usbutils ];

  enableParallelBuilding = true;

  doCheck = true;

  postInstall = ''
    mkdir -p $doc/share/doc/umockdev/
    mv docs/reference $doc/share/doc/umockdev/
  '';

  meta = with lib; {
    description = "Mock hardware devices for creating unit tests";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ flokli ];
    platforms = with platforms; linux;
  };
}
