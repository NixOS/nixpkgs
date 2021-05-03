{ lib, stdenv, fetchurl, pkg-config, gettext, perl, itstool, isocodes, enchant, libxml2, python3
, gnome3, gtksourceview3, libpeas, mate, wrapGAppsHook, mateUpdateScript }:

stdenv.mkDerivation rec {
  pname = "pluma";
  version = "1.24.2";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "183frfhll3sb4r12p24160j1c1cfd102nlp5rrwvyv5qqm7i2fg4";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    perl
    itstool
    isocodes
    wrapGAppsHook
  ];

  buildInputs = [
    enchant
    libxml2
    python3
    gtksourceview3
    libpeas
    gnome3.adwaita-icon-theme
    mate.mate-desktop
  ];

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname version; };

  meta = with lib; {
    description = "Powerful text editor for the MATE desktop";
    homepage = "https://mate-desktop.org";
    license = with licenses; [ gpl2Plus lgpl2Plus fdl11Plus ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
