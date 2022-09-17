{ lib
, stdenv
, fetchurl
, pkg-config
, gettext
, perl
, itstool
, isocodes
, enchant
, libxml2
, python3
, adwaita-icon-theme
, gtksourceview4
, libpeas
, mate-desktop
, wrapGAppsHook
, mateUpdateScript
}:

stdenv.mkDerivation rec {
  pname = "pluma";
  version = "1.26.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0lway12q2xygiwjgrx7chgka838jbnmlzz98g7agag1rwzd481ii";
  };

  nativeBuildInputs = [
    gettext
    isocodes
    itstool
    perl
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    adwaita-icon-theme
    enchant
    gtksourceview4
    libpeas
    libxml2
    mate-desktop
    python3
  ];

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname version; };

  meta = with lib; {
    description = "Powerful text editor for the MATE desktop";
    homepage = "https://mate-desktop.org";
    license = with licenses; [ gpl2Plus lgpl2Plus fdl11Plus ];
    platforms = platforms.unix;
    maintainers = teams.mate.members;
  };
}
