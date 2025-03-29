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
  mpg123,
  opusfile,
  pango,
  pipewire,
  wavpack,
  ffmpeg,
  pulseaudio,
  withDiscordRPC ? true,
}:

python3Packages.buildPythonApplication rec {
  pname = "tauon";
  version = "7.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Taiko2k";
    repo = "Tauon";
    tag = "v${version}";
    hash = "sha256-6aEUniLoE5Qtfht3OAe+zvC9yZwjH+KpskmjGowDuuU=";
  };

  postUnpack = ''
    rmdir source/src/phazor/kissfft
    ln -s ${kissfft.src} source/src/phazor/kissfft

    rmdir source/src/phazor/miniaudio
    ln -s ${miniaudio.src} source/src/phazor/miniaudio
  '';

  postPatch = ''
    substituteInPlace src/tauon/__main__.py \
      --replace-fail 'install_mode = False' 'install_mode = True'

    substituteInPlace src/tauon/t_modules/t_phazor.py \
      --replace-fail 'base_path = Path(pctl.install_directory).parent.parent / "build"' 'base_path = Path("${placeholder "out"}/${python3Packages.python.sitePackages}")'
  '';

  pythonRemoveDeps = [
    "pysdl2-dll"
    "opencc"
    "tekore"
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
      pysdl2
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
      lib.makeLibraryPath [
        game-music-emu
        libopenmpt
        pulseaudio
      ]
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
  '';

  meta = with lib; {
    description = "Linux desktop music player from the future";
    mainProgram = "tauon";
    homepage = "https://tauonmusicbox.rocks/";
    changelog = "https://github.com/Taiko2k/Tauon/releases/tag/v${version}";
    license = licenses.gpl3;
    maintainers = with maintainers; [ jansol ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
