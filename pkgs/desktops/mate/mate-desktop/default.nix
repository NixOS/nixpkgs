{ stdenv, fetchurl, pkgconfig, gettext, isocodes, gnome3, gtk3, dconf, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "mate-desktop";
  version = "1.24.1";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1nd1dn8mm1z6x4r68a25q4vzys1a6fmbzc94ss1z1n1872pczs6i";
  };

  nativeBuildInputs = [
    pkgconfig
    gettext
    wrapGAppsHook
  ];

  buildInputs = [
    dconf
    gtk3
    isocodes
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Library with common API for various MATE modules";
    homepage = "https://mate-desktop.org";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
