{ stdenv
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
  version = "0.15.2";

  outputs = [ "bin" "out" "dev" "doc" ];

  src = fetchurl {
    url = "https://github.com/martinpitt/umockdev/releases/download/${version}/${pname}-${version}.tar.xz";
    sha256 = "19f21qb9ckwvlm7yzpnc0vcp092qbkms2yrafc26b9a63v4imj52";
  };

  mesonFlags = [
    "-Dgtk_doc=true"
  ];

  preCheck = ''
    patchShebangs tests/test-static-code
  '';

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

  # Test fail with libusb 1.0.24
  # https://github.com/NixOS/nixpkgs/issues/107420
  # https://github.com/martinpitt/umockdev/issues/115
  doCheck = false;

  postInstall = ''
    mkdir -p $doc/share/doc/umockdev/
    mv docs/reference $doc/share/doc/umockdev/
  '';

  meta = with stdenv.lib; {
    description = "Mock hardware devices for creating unit tests";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ flokli ];
    platforms = with platforms; linux;
  };
}
