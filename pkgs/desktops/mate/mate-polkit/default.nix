{ stdenv, fetchurl, pkgconfig, intltool, gtk3, gobject-introspection, libappindicator-gtk3, libindicator-gtk3, polkit, mate }:

stdenv.mkDerivation rec {
  name = "mate-polkit-${version}";
  version = "1.22.0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
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
