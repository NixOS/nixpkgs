{ stdenv, fetchurl, pkgconfig, intltool, gtk3, gobject-introspection, libappindicator-gtk3, libindicator-gtk3, polkit }:

stdenv.mkDerivation rec {
  pname = "mate-polkit";
  version = "1.22.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "02r8n71xflhvw2hsf6g4svdahzyg3r4n6xamasyzqfhyn0mqmjy0";
  };

  nativeBuildInputs = [
    gobject-introspection
    intltool
    pkgconfig
  ];

  buildInputs = [
    gtk3
    libappindicator-gtk3
    libindicator-gtk3
    polkit
  ];

  meta = with stdenv.lib; {
    description = "Integrates polkit authentication for MATE desktop";
    homepage = https://mate-desktop.org;
    license = [ licenses.gpl2Plus ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
