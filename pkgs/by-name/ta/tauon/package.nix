{
  lib,
  stdenv,
  fetchFromGitHub,
  kissfft,
  miniaudio,
  pkg-config,
  python3Packages,
  gobject-introspection,
  flac,
  game-music-emu,
  gtk3,
  libappindicator,
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
  wavpack,
  ffmpeg,
  pulseaudio,
  rustPlatform,
  withDiscordRPC ? true,
}:
let
  version = "10.0.1";
  src = fetchFromGitHub {
    owner = "Taiko2k";
    repo = "Tauon";
    tag = "v${version}";
    hash = "sha256-atLyNePy3pc3xJFliy5hITC5R0VU6jfHYqfq8RxqGoM=";
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

  passthru = { inherit lrclib-solver; };

  postUnpack = ''
    rmdir source/src/phazor/kissfft
    ln -s ${kissfft.src} source/src/phazor/kissfft

    rmdir source/src/phazor/miniaudio
    ln -s ${miniaudio.src} source/src/phazor/miniaudio
  '';

  postPatch = ''
    substituteInPlace src/tauon/t_modules/t_phazor.py \
      --replace-fail 'base_path = Path(pctl.install_directory).parent.parent / "build"' 'base_path = Path("${placeholder "out"}/${python3Packages.python.sitePackages}")'
  '';

  pythonRemoveDeps = [
    "opencc"
    "tekore"
    # Not present when withDiscordRPC is disabled.
    "pypresence"
  ];

  nativeBuildInputs = [
    pkg-config
    python3Packages.wrapPython
    gobject-introspection
  ];

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  buildInputs = [
    flac
    game-music-emu
    gtk3
    libappindicator
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
      pysdl3
      requests
      send2trash
      setproctitle
      tidalapi
    ]
    ++ lib.optional withDiscordRPC pypresence
    ++ lib.optional stdenv.hostPlatform.isLinux pulsectl;

  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [ ffmpeg ]}"
    "--prefix LD_LIBRARY_PATH : ${
      lib.makeLibraryPath (
        [
          game-music-emu
          libopenmpt
          pulseaudio
        ]
        ++ lib.optional stdenv.hostPlatform.isLinux libxcursor
      )
    }"
    "--prefix PYTHONPATH : $out/share/tauon"
    "--set GI_TYPELIB_PATH $GI_TYPELIB_PATH"
  ];

  postInstall = ''
    mv $out/bin/tauonmb $out/bin/tauon
    mkdir -p $out/share/applications
    install -Dm755 extra/tauonmb.desktop $out/share/applications/tauonmb.desktop
    mkdir -p $out/share/icons/hicolor/scalable/apps
    install -Dm644 extra/tauonmb{,-symbolic}.svg $out/share/icons/hicolor/scalable/apps
    ln -s ${lib.getExe lrclib-solver} $out/${python3Packages.python.sitePackages}/tauon/lrclib-solver
  '';

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
