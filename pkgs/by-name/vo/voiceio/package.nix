{
  lib,
  python3Packages,
  fetchFromGitHub,
  wrapGAppsHook3,
  gobject-introspection,
  at-spi2-core,
  gdk-pixbuf,
  gtk3,
  harfbuzz,
  pango,
  ibus,
  libayatana-appindicator,
  libnotify,
  procps,
  wl-clipboard,
  wtype,
  xclip,
  xdotool,
  ydotool,
}:
let
  runtimeDeps = with python3Packages; [
    faster-whisper
    numpy
    onnxruntime
    wordfreq
    sounddevice
    evdev
    pynput
    pystray
    pillow
  ];

  # The IBus engine and the AppIndicator tray run under an interpreter that
  # has PyGObject; voiceio finds it through VOICEIO_SYSTEM_PYTHON.
  systemPython = python3Packages.python.withPackages (ps: runtimeDeps ++ [ ps.pygobject3 ]);
in
python3Packages.buildPythonApplication rec {
  pname = "voiceio";
  version = "1.15.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Hugo0";
    repo = "voiceio";
    tag = "v${version}";
    hash = "sha256-Bh5YMT9ZHRRMJZX2i+altxj20ETUZH/aILw67s/urY8=";
  };

  build-system = with python3Packages; [
    setuptools
    wheel
  ];

  dependencies = runtimeDeps;

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
  ];

  buildInputs = [
    gtk3
    ibus
    libayatana-appindicator
  ];

  # Fold the GApps environment into the Python wrapper (see preFixup)
  # instead of wrapping every program twice.
  dontWrapGApps = true;

  pythonImportsCheck = [
    "voiceio"
    "voiceio.core.engine"
  ];

  doCheck = false;

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pytest-mock
    aiohttp
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      ibus
      libnotify
      procps
      wl-clipboard
      wtype
      xclip
      xdotool
      ydotool
    ])
    "--prefix"
    "GI_TYPELIB_PATH"
    ":"
    (lib.makeSearchPath "lib/girepository-1.0" [
      at-spi2-core
      gdk-pixbuf
      gobject-introspection
      gtk3
      harfbuzz
      ibus
      libayatana-appindicator
      pango.out
    ])
    "--set"
    "VOICEIO_SYSTEM_PYTHON"
    "${systemPython}/bin/python3"
  ];

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  passthru = { inherit systemPython; };

  meta = {
    description = "Voice dictation for Linux. Speak -> text, locally, instantly";
    homepage = "https://github.com/Hugo0/voiceio";
    changelog = "https://github.com/Hugo0/voiceio/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kosoyyagent ];
    mainProgram = "voiceio";
    platforms = lib.platforms.linux;
  };
}
