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
  version = "14.0.0";
  src = fetchFromGitHub {
    owner = "Taiko2k";
    repo = "Tauon";
    tag = "v${version}";
    hash = "sha256-IKPNXKVI1hDrl3uJEBqYu2HU4YewaP1L0tJ6bup3YG8=";
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
    sdl3
    wavpack
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux pipewire;

  pythonPath =
    with python3Packages;
    [
      beautifulsoup4
      colored-traceback
      jxlpy
      musicbrainzngs
      mutagen
      natsort
      opencc
      pillow
      plexapi
      pycairo
      pychromecast
      pygobject3
      pylast
      pyopengl
      rapidfuzz
      requests
      send2trash
      setproctitle
      tidalapi
      unidecode
      zeroconf
    ]
    ++ lib.optional withDiscordRPC pypresence
    ++ lib.optional stdenv.hostPlatform.isLinux dbus-python;

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
        libopenmpt
        pulseaudio
      ]
      ++ lib.optionals stdenv.hostPlatform.isLinux [
        libayatana-appindicator
        libxcursor
      ]
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

    mkdir -p $out/share/metainfo
    install -Dm644 extra/com.github.taiko2k.tauonmb.metainfo.xml -t $out/share/metainfo
    # desktop-id launchable tag must match the desktop file path in share/applications.
    # https://www.freedesktop.org/software/appstream/docs/chap-Metadata.html#tag-launchable
    substituteInPlace $out/share/metainfo/com.github.taiko2k.tauonmb.metainfo.xml --replace-fail com.github.taiko2k.tauonmb.desktop tauonmb.desktop

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
