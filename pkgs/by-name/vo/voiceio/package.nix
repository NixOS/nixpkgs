# voiceio for nixpkgs — adapted from upstream's nix/package.nix (which follows
# NostraDavid's nixcfg derivation), converted to a fetchPypi by-name package.
# NOTE: not yet test-built (no Nix toolchain on the prep machine); CI (ofborg)
# will build it on the PR.
{
  lib,
  python3Packages,
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
  procps,
  wl-clipboard,
  wtype,
  xclip,
  xdotool,
  ydotool,
}:

let
  # Base + `desktop` extra. `server`/`tts`/`train`/`sherpa` stay opt-in.
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
  systemPython = python3Packages.python.withPackages (
    ps: runtimeDeps ++ [ ps.pygobject3 ]
  );
in
python3Packages.buildPythonApplication rec {
  pname = "python-voiceio";
  version = "1.15.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-H+C/01/BNYqtbosTMr5v8cuJe8h7XT+BFbzLJpaRaRw=";
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

  # Upstream runs its test suite in its flake checks, not on every build.
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

  passthru = { inherit systemPython; };

  meta = {
    description = "Offline voice dictation for Linux";
    homepage = "https://github.com/Hugo0/voiceio";
    changelog = "https://github.com/Hugo0/voiceio/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "voiceio";
    platforms = lib.platforms.linux;
  };
}
