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
  runtimeDeps = with python3.pkgs; [
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
python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "voiceio";
  version = "1.18.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Hugo0";
    repo = "voiceio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GN8xtd4n09t3ppjn6ot8mzVQNdMX2LfTefUVvlyL07o=";
  };

  build-system = with python3.pkgs; [
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
    (lib.getExe systemPython)
  ];

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    description = "Offline voice dictation for Linux using faster-whisper";
    homepage = "https://github.com/Hugo0/voiceio";
    changelog = "https://github.com/Hugo0/voiceio/releases/tag/v${finalAttrs.version}";
    # Bundles the Silero VAD model (voiceio/models/silero_vad.onnx), which is
    # MIT licensed like the code. Whisper/Parakeet weights are not shipped;
    # they are downloaded at runtime under their own licenses (MIT /
    # CC-BY-4.0), see upstream docs/models.md.
    license = lib.licenses.mit;
    mainProgram = "voiceio";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.trvorth ];
  };
})
