{
  lib,
  stdenv,
  fetchFromGitHub,

  cmake,
  gettext,
  wrapGAppsHook3,
  pkg-config,
  help2man,

  adwaita-icon-theme,
  alsa-lib,
  binutils,
  glib,
  gsettings-desktop-schemas,
  gtk3,
  gtksourceview4,
  librsvg,
  libsndfile,
  libxml2,
  libzip,
  pcre,
  poppler,
  portaudio,
  qpdf,
  zlib,
  # plugins
  withLua ? true,
  lua5_3,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "xournalpp";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "xournalpp";
    repo = "xournalpp";
    rev = "v${version}";
    hash = "sha256-adzL/2zQlG4hBPV0rQzkQrOyGROv73GyjIH8Debhhq8=";
  };

  nativeBuildInputs = [
    cmake
    gettext
    pkg-config
    wrapGAppsHook3
    help2man
  ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      alsa-lib
    ]
    ++ [
      glib
      gsettings-desktop-schemas
      gtk3
      gtksourceview4
      librsvg
      libsndfile
      libxml2
      libzip
      pcre
      poppler
      portaudio
      qpdf
      zlib
    ]
    ++ lib.optional withLua lua5_3;

  buildFlags = [ "translations" ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${adwaita-icon-theme}/share"
    )
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Xournal++ is a handwriting Notetaking software with PDF annotation support";
    homepage = "https://xournalpp.github.io/";
    changelog = "https://github.com/xournalpp/xournalpp/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      iedame
      sikmir
    ];
    platforms = lib.platforms.unix;
    mainProgram = "xournalpp";
  };
}
