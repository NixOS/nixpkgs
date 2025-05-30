{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gettext,
  perl,
  itstool,
  isocodes,
  enchant,
  libxml2,
  python3,
  gtksourceview4,
  libpeas,
  mate-desktop,
  wrapGAppsHook3,
  mateUpdateScript,
}:

stdenv.mkDerivation rec {
  pname = "pluma";
  version = "1.28.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "qorflYk0UJOlDjCyft5KeKJCHRcnwn9GX8h8Q1llodQ=";
  };

  nativeBuildInputs = [
    gettext
    isocodes
    itstool
    perl
    pkg-config
    python3.pkgs.wrapPython
    wrapGAppsHook3
  ];

  buildInputs = [
    enchant
    gtksourceview4
    libpeas
    libxml2
    mate-desktop
    python3
  ];

  enableParallelBuilding = true;

  pythonPath = with python3.pkgs; [
    pycairo
    six
  ];

  postFixup = ''
    buildPythonPath "$pythonPath"
    patchPythonScript $out/lib/pluma/plugins/snippets/Snippet.py
  '';

  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "Powerful text editor for the MATE desktop";
    mainProgram = "pluma";
    homepage = "https://mate-desktop.org";
    license = with licenses; [
      gpl2Plus
      lgpl2Plus
      fdl11Plus
    ];
    platforms = platforms.unix;
    teams = [ teams.mate ];
  };
}
