{ stdenv
, lib
, docbook-xsl-nons
, fetchurl
, fetchpatch
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

  outputs = [ "bin" "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "https://github.com/martinpitt/umockdev/releases/download/${version}/${pname}-${version}.tar.xz";
    sha256 = "09k8jwvsphd97hcagf0zaf0hwzlzq2r8jfgbmvj55k7ylrg8hjxg";
  };

  patches = [
    # Fix build with Vala 0.52
    (fetchpatch {
      url = "https://github.com/martinpitt/umockdev/commit/a236f0b55fbb6ff50a6429da9d404703d6637d94.patch";
      sha256 = "sZs9Ove1r7te/a9vmWUmFetLVhyzhHmx7ijhkK/2S5o=";
    })
  ];

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
