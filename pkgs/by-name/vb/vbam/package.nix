{
  lib,
  stdenv,
  cairo,
  cmake,
  fetchFromGitHub,
  ffmpeg_7,
  gettext,
  wxGTK32,
  gtk3,
  libGLU,
  libGL,
  openal,
  pkg-config,
  SDL2,
  sfml_2,
  zip,
  zlib,
  wrapGAppsHook3,
  gsettings-desktop-schemas,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "visualboyadvance-m";
  version = "2.2.3";
  src = fetchFromGitHub {
    owner = "visualboyadvance-m";
    repo = "visualboyadvance-m";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/yvwr3Of4aox4pOBwiC4gUzGsrPDwaFYPgJVivuOAvo=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    cairo
    ffmpeg_7
    gettext
    libGLU
    libGL
    openal
    SDL2
    sfml_2
    zip
    zlib
    wxGTK32
    gtk3
    gsettings-desktop-schemas
  ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_FFMPEG" true)
    (lib.cmakeBool "ENABLE_LINK" true)
    (lib.cmakeFeature "SYSCONFDIR" "etc")
    (lib.cmakeBool "ENABLE_SDL" true)
  ];

  meta = {
    description = "Merge of the original Visual Boy Advance forks";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [
      lassulus
      netali
    ];
    homepage = "https://www.visualboyadvance-m.org/";
    platforms = lib.platforms.linux;
    mainProgram = "visualboyadvance-m";
  };
})
