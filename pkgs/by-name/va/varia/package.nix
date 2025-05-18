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
  version = "2025.4.22";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "giantpinkrobots";
    repo = "varia";
    tag = "v${version}";
    hash = "sha256-y14I/K1fw7Skiuq+CglTRsotqafpP9yabuHhywB2WXE=";
  };

  postPatch = ''
    substituteInPlace src/varia-py.in \
      --replace-fail 'aria2cexec = sys.argv[1]' 'aria2cexec = "${lib.getExe aria2}"' \
      --replace-fail 'ffmpegexec = sys.argv[2]' 'ffmpegexec = "${lib.getExe ffmpeg}"'
  '';

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

  propagatedBuildInputs = with python3Packages; [
    pygobject3
    aria2p
    yt-dlp
  ];

  postInstall = ''
    rm $out/bin/varia
    mv $out/bin/varia-py.py $out/bin/varia
  '';

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "Simple download manager based on aria2 and libadwaita";
    homepage = "https://giantpinkrobots.github.io/varia";
    license = licenses.mpl20;
    mainProgram = "varia";
    maintainers = with maintainers; [ aleksana ];
    platforms = platforms.linux;
  };
}
