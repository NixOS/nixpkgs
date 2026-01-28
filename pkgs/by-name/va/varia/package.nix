{
  lib,
  python3Packages,
  fetchFromGitHub,
  aria2,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  wrapGAppsHook4,
  desktop-file-utils,
  libadwaita,
  ffmpeg,
}:

python3Packages.buildPythonApplication rec {
  pname = "varia";
  version = "2026.1.5-2";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "giantpinkrobots";
    repo = "varia";
    tag = "v${version}";
    hash = "sha256-jb7xIEWvqtVuTPa1wZvjOJlZa5mCAqbnxK8h3whHm/k=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [
    libadwaita
  ];

  dependencies = with python3Packages; [
    pygobject3
    aria2p
    yt-dlp
    emoji-country-flag
  ];

  postInstall = ''
    rm $out/bin/varia
    mv $out/bin/varia-py.py $out/bin/varia
  '';

  dontWrapGApps = true;

  # This replaces original varia wrapper
  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      --add-flag "${lib.getExe aria2}"
      --add-flag "${lib.getExe ffmpeg}"
      --add-flag "NOSNAP"
    )
  '';

  meta = {
    description = "Simple download manager based on aria2 and libadwaita";
    homepage = "https://giantpinkrobots.github.io/varia";
    license = lib.licenses.mpl20;
    mainProgram = "varia";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
}
