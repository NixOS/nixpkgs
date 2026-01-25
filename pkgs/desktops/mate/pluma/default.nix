{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf-archive,
  autoreconfHook,
  pkg-config,
  gettext,
  perl,
  itstool,
  isocodes,
  enchant,
  gtk-doc,
  libxml2,
  mate-common,
  python3,
  gtksourceview4,
  libpeas,
  mate-desktop,
  wrapGAppsHook3,
  yelp-tools,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pluma";
  version = "1.28.1";

  src = fetchFromGitHub {
    owner = "mate-desktop";
    repo = "pluma";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-+3zY3A7JRc7utYMNiQBnsy0lZr1PuDSOtdP+iigNRDQ=";
  };

  nativeBuildInputs = [
    autoconf-archive
    autoreconfHook
    gettext
    isocodes
    itstool
    gtk-doc
    mate-common # mate-common.m4 macros
    perl
    pkg-config
    python3.pkgs.wrapPython
    wrapGAppsHook3
    yelp-tools
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
  ];

  postFixup = ''
    buildPythonPath "$pythonPath"
    patchPythonScript $out/lib/pluma/plugins/snippets/Snippet.py
  '';

  passthru.updateScript = gitUpdater {
    odd-unstable = true;
    rev-prefix = "v";
  };

  meta = {
    description = "Powerful text editor for the MATE desktop";
    mainProgram = "pluma";
    homepage = "https://mate-desktop.org";
    license = with lib.licenses; [
      gpl2Plus
      lgpl2Plus
      fdl11Plus
    ];
    platforms = lib.platforms.unix;
    teams = [ lib.teams.mate ];
  };
})
