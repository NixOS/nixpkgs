{ lib, stdenv
, docbook_xsl
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

  outputs = [ "bin" "out" "dev" "doc" ];

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
