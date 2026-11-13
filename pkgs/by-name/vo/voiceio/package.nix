{
  lib,
  at-spi2-core,
  fetchFromGitHub,
  gdk-pixbuf,
  gobject-introspection,
  gtk3,
  harfbuzz,
  ibus,
  libayatana-appindicator,
  libnotify,
  pango,
  procps,
  python3,
  wl-clipboard,
  wrapGAppsHook3,
  wtype,
  xclip,
  xdotool,
  ydotool,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "python-voiceio";
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

  dependencies = with python3.pkgs; [
    evdev
    faster-whisper
    numpy
    onnxruntime
    pillow
    pynput
    pystray
    sounddevice
    wordfreq
  ];

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    ibus
    libayatana-appindicator
  ];

  # The GApps environment is folded into the single Python wrapper in preFixup.
  dontWrapGApps = true;

  # The test suite needs model downloads; the flake runs it separately.
  doCheck = false;

  pythonImportsCheck = [ "voiceio" ];

  makeWrapperArgs =
    let
      # IBus engine and AppIndicator tray run under an interpreter that has
      # PyGObject; voiceio looks it up through VOICEIO_SYSTEM_PYTHON.
      systemPython = python3.withPackages (
        ps: with ps; [
          evdev
          faster-whisper
          numpy
          onnxruntime
          pillow
          pynput
          pystray
          pygobject3
          sounddevice
          wordfreq
        ]
      );
    in
    [
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

  meta = {
    description = "Local voice dictation for Linux: speak, and the text appears at your cursor";
    homepage = "https://voiceio.dev/";
    license = lib.licenses.mit;
    mainProgram = "voiceio";
    platforms = lib.platforms.linux;
  };
})
