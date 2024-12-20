{
  lib,
  fetchFromGitHub,
  ffmpeg,
  python3Packages,
  meson,
  yt-dlp,
  wrapGAppsHook4,
  desktop-file-utils,
  ninja,
  gobject-introspection,
  glib,
  pkg-config,
  gtk4,
  librsvg,
  libadwaita,
}:

python3Packages.buildPythonApplication rec {
  pname = "video-downloader";
  version = "0.12.20";
  pyproject = false; # Built with meson

  src = fetchFromGitHub {
    owner = "Unrud";
    repo = "video-downloader";
    tag = "v${version}";
    hash = "sha256-UaSEcqD4hYRacQfLHgkXgO+/lIV5GxMX9NDOTLhTw+o=";
  };

  propagatedBuildInputs = with python3Packages; [
    pygobject3
    yt-dlp
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    wrapGAppsHook4
    desktop-file-utils
    gobject-introspection
  ];

  buildInputs = [
    glib
    gtk4
    librsvg
    libadwaita
  ];

  # would require network connectivity
  doCheck = false;

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      --prefix PATH : ${lib.makeBinPath [ ffmpeg ]}
    )
  '';

  meta = {
    homepage = "https://github.com/Unrud/video-downloader";
    changelog = "https://github.com/Unrud/video-downloader/releases";
    description = "GUI application based on yt-dlp";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fliegendewurst ];
    mainProgram = "video-downloader";
  };
}
