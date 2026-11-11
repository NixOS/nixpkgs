{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gettext,
  kissfft,
  miniaudio,
  ninja,
  pkg-config,
  python3Packages,
  gobject-introspection,
  chromaprint,
  flac,
  game-music-emu,
  gtk3,
  libayatana-appindicator,
  libnotify,
  libopenmpt,
  librsvg,
  libsamplerate,
  libvorbis,
  libxcursor,
  mpg123,
  opusfile,
  pango,
  pipewire,
  sdl3,
  wavpack,
  ffmpeg,
  pulseaudio,
  rustPlatform,
  withDiscordRPC ? true,
}:
let
  version = "13.1.1";
  src = fetchFromGitHub {
    owner = "Taiko2k";
    repo = "Tauon";
    tag = "v${version}";
    hash = "sha256-OCRk1aa1JNt96n3d00tGJlDFJD2v4jKwMXoN25p+y4o=";
  };

  lrclib-solver = rustPlatform.buildRustPackage {
    pname = "lrclib-solver";
    inherit version;
    src = "${src}/src/lrclib-solver";
    cargoHash = "sha256-uNEf0d462W9mJHGLeAE/aLjpyzKT5orKZ7BYQ+53msY=";

    meta = {
      mainProgram = "lrclib-solver";
      license = lib.licenses.gpl3;
      maintainers = with lib.maintainers; [
        jansol
        alfarel
      ];
      platforms = lib.platforms.linux ++ lib.platforms.darwin;
    };
  };
in
python3Packages.buildPythonApplication {
  pname = "tauon";
  pyproject = true;
  inherit version src;

  postUnpack = ''
    rmdir source/src/phazor/kissfft
    ln -s ${kissfft.src} source/src/phazor/kissfft

    rmdir source/src/phazor/miniaudio
    ln -s ${miniaudio.src} source/src/phazor/miniaudio
  '';

  pythonRemoveDeps = [
    # Not present when withDiscordRPC is disabled.
    "pypresence"
  ];

  # scikit-build-core owns the CMake configure/build lifecycle for the wheel.
  dontUseCmakeConfigure = true;

  # tauon is a C++ binary embedding Python, so wrapPythonPrograms ignores it.
  dontWrapPythonPrograms = true;

  nativeBuildInputs = [
    cmake
    gettext
    ninja
    pkg-config
    python3Packages.wrapPython
    gobject-introspection
  ];

  build-system = with python3Packages; [
    scikit-build-core
  ];

  buildInputs = [
    flac
    game-music-emu
    gtk3
    libnotify
    libopenmpt
    librsvg
    libsamplerate
    libvorbis
    mpg123
    opusfile
    pango
    pipewire
    python3Packages.pyopengl
    sdl3
    wavpack
  ];

  pythonPath =
    with python3Packages;
    [
      beautifulsoup4
      colored-traceback
      dbus-python
      unidecode
      jxlpy
      musicbrainzngs
      mutagen
      natsort
      pillow
      plexapi
      pycairo
      pychromecast
      pylast
      pygobject3
      pyopengl
      rapidfuzz
      requests
      send2trash
      setproctitle
      tidalapi
      zeroconf
    ]
    ++ lib.optional withDiscordRPC pypresence
    ++ lib.optional stdenv.hostPlatform.isLinux pulsectl;

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ ffmpeg ])
    "--prefix"
    "LD_LIBRARY_PATH"
    ":"
    (lib.makeLibraryPath (
      [
        chromaprint
        game-music-emu
        libayatana-appindicator
        libopenmpt
        pulseaudio
      ]
      ++ lib.optional stdenv.hostPlatform.isLinux libxcursor
    ))
  ];

  postFixup = ''
    buildPythonPath "$out ''${pythonPath[*]}"
    wrapProgram $out/bin/tauon \
      --prefix PATH : "$program_PATH" \
      --prefix PYTHONPATH : "$program_PYTHONPATH" \
      --set PYTHONNOUSERSITE "true" \
      --set GI_TYPELIB_PATH "$GI_TYPELIB_PATH" \
      ''${makeWrapperArgs[@]}
  '';

  postInstall = ''
    mkdir -p $out/share/applications
    install -Dm755 extra/tauonmb.desktop $out/share/applications/tauonmb.desktop
    mkdir -p $out/share/icons/hicolor/scalable/apps
    install -Dm644 extra/tauonmb{,-symbolic}.svg $out/share/icons/hicolor/scalable/apps
    ln -s ${lib.getExe lrclib-solver} $out/${python3Packages.python.sitePackages}/tauon/lrclib-solver
  '';

  passthru = { inherit lrclib-solver; };

  meta = {
    description = "Linux desktop music player from the future";
    mainProgram = "tauon";
    homepage = "https://tauonmusicbox.rocks/";
    changelog = "https://github.com/Taiko2k/Tauon/releases/tag/v${version}";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      jansol
      alfarel
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
