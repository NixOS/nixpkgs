{ stdenv, fetchurl, pkgconfig, gettext, gtk3, gobject-introspection, libappindicator-gtk3, libindicator-gtk3, polkit }:

stdenv.mkDerivation rec {
  pname = "mate-polkit";
  version = "1.24.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1450bqzlnvwy3xa98lj102j2cf7piqbxcd1cy2zp41rdl8ri3gvn";
  };

  nativeBuildInputs = [
    gobject-introspection
    gettext
    pkgconfig
  ];

  buildInputs = [
    gtk3
    libappindicator-gtk3
    libindicator-gtk3
    polkit
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Integrates polkit authentication for MATE desktop";
    homepage = "https://mate-desktop.org";
    license = [ licenses.gpl2Plus ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
