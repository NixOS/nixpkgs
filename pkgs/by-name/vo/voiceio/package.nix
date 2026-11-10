{
  lib,
  python3,
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
  py = python3.pkgs;

  runtimeDeps = with py; [
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

  systemPython = python3.withPackages (ps: runtimeDeps ++ [ ps.pygobject3 ]);
in
py.buildPythonApplication rec {
  pname = "voiceio";
  version = "1.17.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Hugo0";
    repo = "voiceio";
    tag = "v${version}";
    hash = "sha256-JaxgES628uAggK3/LQ10R479bgYOkoby7oMCfqTsYhQ=";
  };

  build-system = with py; [
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

  dontWrapGApps = true;

  pythonImportsCheck = [
    "voiceio"
    "voiceio.core.engine"
  ];

  doCheck = false;

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

  passthru = {
    inherit systemPython;
  };

  meta = {
    description = "Offline voice dictation for Linux using faster-whisper";
    homepage = "https://github.com/Hugo0/voiceio";
    changelog = "https://github.com/Hugo0/voiceio/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "voiceio";
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
