{ lib
, stdenv
, fetchurl
, pkg-config
, gettext
, itstool
, libxml2
, gtk3
, file
, mate
, hicolor-icon-theme
, wrapGAppsHook
, mateUpdateScript
}:

stdenv.mkDerivation rec {
  pname = "engrampa";
  version = "1.27.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-G7dX1y0DeH8kddheB0GzzQ90XpVvpVvGbHkhMlxQEw8=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    itstool
    wrapGAppsHook
  ];

  buildInputs = [
    libxml2
    gtk3
    file #libmagic
    mate.caja
    hicolor-icon-theme
    mate.mate-desktop
  ];

  configureFlags = [
    "--with-cajadir=$$out/lib/caja/extensions-2.0"
    "--enable-magic"
  ];

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "Archive Manager for MATE";
    homepage = "https://mate-desktop.org";
    license = with licenses; [ gpl2Plus lgpl2Plus fdl11Plus ];
    platforms = platforms.unix;
    maintainers = teams.mate.members;
  };
}
