{
  lib,
  python3Packages,
  fetchPypi,
  gobject-introspection,
  wrapGAppsHook3,
  gtk3,
  libayatana-appindicator,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "voiceio";
  version = "1.15.2";
  pyproject = true;

  src = fetchPypi {
    pname = "python-voiceio";
    inherit version;
    hash = "sha256-H+C/01/BNYqtbosTMr5v8cuJe8h7XT+BFbzLJpaRaRw=";
  };

  build-system = with python3Packages; [
    setuptools
    wheel
  ];

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    libayatana-appindicator
  ];

  dependencies = with python3Packages; [
    faster-whisper
    numpy
    onnxruntime
    wordfreq
    # `desktop` extra: microphone capture, global hotkeys, tray icon
    sounddevice
    evdev
    pynput
    pystray
    pillow
  ];

  # Fold the GApps environment into the Python wrapper instead of
  # wrapping every program twice.
  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  # The upstream test suite needs a microphone and a display session;
  # it is exercised by the project's own flake checks, not at build time.
  doCheck = false;

  pythonImportsCheck = [ "voiceio" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Offline voice dictation for Linux: speak and text streams into the focused app, decoded fully on-device";
    homepage = "https://voiceio.dev";
    license = lib.licenses.mit;
    mainProgram = "voiceio";
    platforms = lib.platforms.linux;
  };
}
