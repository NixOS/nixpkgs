{ lib
, fetchFromGitHub
, python3
, meson
, yt-dlp
, wrapGAppsHook4
, desktop-file-utils
, ninja
, gobject-introspection
, glib
, pkg-config
, gtk4
, librsvg
, libadwaita
}:

python3.pkgs.buildPythonApplication rec {
  pname = "video-downloader";
  version = "0.12.9";
  format = "other";

  src = fetchFromGitHub {
    owner = "Unrud";
    repo = "video-downloader";
    rev = "v${version}";
    hash = "sha256-3eJQg7GAv5r0yCSj4A8k2Zhfbawzax7x4CZAyg3lU0Y=";
  };

  propagatedBuildInputs = with python3.pkgs; [
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
    )
  '';

  meta = with lib; {
    homepage = "https://github.com/Unrud/video-downloader";
    description = "GUI application based on yt-dlp";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fliegendewurst ];
    mainProgram = "video-downloader";
  };
}
