{ lib
, stdenv
, fetchurl
, pkg-config
, gettext
, gtk3
, libnotify
, libxml2
, libexif
, exempi
, mate
, hicolor-icon-theme
, wrapGAppsHook
, mateUpdateScript
}:

stdenv.mkDerivation rec {
  pname = "caja";
  version = "1.26.1";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "MP1ubwCjggD24uiYrX+nl4drsGDx0DQd0vc5MnnhTAc=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    libnotify
    libxml2
    libexif
    exempi
    mate.mate-desktop
    hicolor-icon-theme
  ];

  configureFlags = [ "--disable-update-mimedb" ];

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname version; };

  meta = with lib; {
    description = "File manager for the MATE desktop";
    homepage = "https://mate-desktop.org";
    license = with licenses; [ gpl2Plus lgpl2Plus ];
    platforms = platforms.unix;
    maintainers = teams.mate.members;
  };
}
