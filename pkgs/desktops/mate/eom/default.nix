{ lib
, stdenv
, fetchurl
, pkg-config
, gettext
, itstool
, exempi
, lcms2
, libexif
, libjpeg
, librsvg
, libxml2
, libpeas
, shared-mime-info
, gtk3
, mate
, hicolor-icon-theme
, wrapGAppsHook
, mateUpdateScript
}:

stdenv.mkDerivation rec {
  pname = "eom";
  version = "1.26.1";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "tSUSKUlPfmxi4J+yEeQzCN9PB0xVG6CiM9ws1oZLmWA=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    itstool
    wrapGAppsHook
  ];

  buildInputs = [
    exempi
    lcms2
    libexif
    libjpeg
    librsvg
    libxml2
    shared-mime-info
    gtk3
    libpeas
    mate.mate-desktop
    hicolor-icon-theme
  ];

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "An image viewing and cataloging program for the MATE desktop";
    homepage = "https://mate-desktop.org";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = teams.mate.members;
  };
}
