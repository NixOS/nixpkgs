{ lib, stdenv, fetchurl, pkg-config, gettext, isocodes, gnome3, gtk3, dconf, wrapGAppsHook, mateUpdateScript }:

stdenv.mkDerivation rec {
  pname = "mate-desktop";
  version = "1.24.1";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1nd1dn8mm1z6x4r68a25q4vzys1a6fmbzc94ss1z1n1872pczs6i";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    wrapGAppsHook
  ];

  buildInputs = [
    dconf
    gtk3
    isocodes
  ];

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname version; };

  meta = with lib; {
    description = "Library with common API for various MATE modules";
    homepage = "https://mate-desktop.org";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
