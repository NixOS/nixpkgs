{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gettext,
  itstool,
  gtk3,
  libmpc,
  libxml2,
  mpfr,
  wrapGAppsHook3,
  mateUpdateScript,
}:

stdenv.mkDerivation rec {
  pname = "mate-calc";
  version = "1.28.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "gEsSXR4oZLHnSvgW2psquLGUcrmvl0Q37nNVraXmKPU=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    gettext
    itstool
    libxml2 # xmllint
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    libmpc
    libxml2
    mpfr
  ];

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "Calculator for the MATE desktop";
    homepage = "https://mate-desktop.org";
    license = [ licenses.gpl2Plus ];
    platforms = platforms.linux;
    maintainers = teams.mate.members;
  };
}
