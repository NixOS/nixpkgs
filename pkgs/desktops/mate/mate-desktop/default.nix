{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gettext,
  isocodes,
  libstartup_notification,
  gtk3,
  dconf,
  wrapGAppsHook3,
  mateUpdateScript,
}:

stdenv.mkDerivation rec {
  pname = "mate-desktop";
  version = "1.28.2";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "MrtLeSAUs5HB4biunBioK01EdlCYS0y6fSjpVWSWSqI=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    wrapGAppsHook3
  ];

  buildInputs = [
    dconf
    isocodes
  ];

  propagatedBuildInputs = [
    gtk3
    libstartup_notification
  ];

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "Library with common API for various MATE modules";
    homepage = "https://mate-desktop.org";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = teams.mate.members;
  };
}
