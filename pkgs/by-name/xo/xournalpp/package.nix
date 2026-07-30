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
  glib,
  gsettings-desktop-schemas,
  gtk3,
  gtksourceview4,
  librsvg,
  libsndfile,
  libxml2,
  libzip,
  poppler,
  portaudio,
  qpdf,
  zlib,
  # plugins
  withLua ? true,
  lua5_3,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xournalpp";
  version = "1.3.6";

  src = fetchFromGitHub {
    owner = "xournalpp";
    repo = "xournalpp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eSKGu0l3Hif+MlT+5jjLkUYUuglnONasyA6AQiHb32s=";
  };

  nativeBuildInputs = [
    cmake
    gettext
    pkg-config
    wrapGAppsHook3
    help2man
  ];

  buildInputs = [
    glib
    gsettings-desktop-schemas
    gtk3
    gtksourceview4
    librsvg
    libsndfile
    libxml2
    libzip
    poppler
    portaudio
    qpdf
    zlib
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux alsa-lib
  ++ lib.optional withLua lua5_3;

  buildFlags = [ "translations" ];

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace $out/share/thumbnailers/com.github.xournalpp.xournalpp.thumbnailer \
      --replace-fail "Exec=xournalpp-thumbnailer" "Exec=$out/bin/xournalpp-thumbnailer"
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${adwaita-icon-theme}/share"
    )
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Xournal++ is a handwriting Notetaking software with PDF annotation support";
    homepage = "https://xournalpp.github.io/";
    changelog = "https://github.com/xournalpp/xournalpp/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      iedame
      sikmir
    ];
    platforms = lib.platforms.unix;
    mainProgram = "xournalpp";
  };
})
