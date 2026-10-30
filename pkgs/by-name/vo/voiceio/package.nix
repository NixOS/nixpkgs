{
  lib,
  python3,
  fetchPypi,
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
  portaudio,
  procps,
  wl-clipboard,
  wtype,
  xclip,
  xdotool,
  ydotool,
}:

let
  py = python3.pkgs;

  # Base dependencies plus the `desktop` extra (microphone, hotkeys, tray).
  # The `server`, `tts`, `train` and `sherpa` extras stay opt-in.
  runtimeDeps = [
    py.numpy
    py.pillow
    py."faster-whisper"
    py.onnxruntime
    py.wordfreq
    py.sounddevice
    py.evdev
    py.pynput
    py.pystray
  ];

  # The IBus engine and the AppIndicator tray run under an interpreter that
  # has PyGObject; voiceio finds it through VOICEIO_SYSTEM_PYTHON.
  systemPython = python3.withPackages (ps: runtimeDeps ++ [ ps.pygobject3 ]);
in
py.buildPythonApplication (finalAttrs: {
  pname = "voiceio";
  version = "1.15.1";
  pyproject = true;

  src = fetchPypi {
    pname = "python-voiceio";
    inherit (finalAttrs) version;
    hash = "sha256-453d71488ea97833e174d72ab112678a6cd0d4c67a588fd5f48b3040031f8763";
  };

  build-system = [
    py.setuptools
    py.wheel
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
    portaudio
  ];

  # Fold the GApps environment into the Python wrapper (see preFixup)
  # instead of wrapping every program twice.
  dontWrapGApps = true;

  pythonImportsCheck = [
    "voiceio"
    "voiceio.core.engine"
  ];

  # Tests run in the upstream flake's `checks.pytest`, not on every build.
  doCheck = false;

  # One wrapper per program: buildPythonApplication's own wrapper picks up
  # makeWrapperArgs, and the GApps hook's args are appended to it.
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
    description = "Local voice dictation for Linux: speak, and the text appears at your cursor";
    homepage = "https://github.com/Hugo0/voiceio";
    changelog = "https://github.com/Hugo0/voiceio/releases";
    license = lib.licenses.mit;
    mainProgram = "voiceio";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.kazuya ];
  };
})
