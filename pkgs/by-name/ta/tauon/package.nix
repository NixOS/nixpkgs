{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPypi,
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
  withDiscordRPC ? true,
}:

let
  # fork of pypresence, to be reverted if/when there's an upstream release
  lynxpresence = python3Packages.buildPythonPackage rec {
    pname = "lynxpresence";
    version = "4.6.2";
    pyproject = true;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-w4WShLTTSf4JGQVL4lTkbOLL8C7cjnf8WwHyfwKK2zA=";
    };

    build-system = with python3Packages; [ setuptools ];

    doCheck = false; # tests require internet connection
    pythonImportsCheck = [ "lynxpresence" ];
  };
in
python3Packages.buildPythonApplication rec {
  pname = "tauon";
  version = "8.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Taiko2k";
    repo = "Tauon";
    tag = "v${version}";
    hash = "sha256-d7bEC68ZJthJE/AlcUqBSNM4L4YAjwHXTiWDCtKf598=";
  };

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
      pysdl3
      requests
      send2trash
      setproctitle
      tidalapi
    ]
    ++ lib.optional withDiscordRPC lynxpresence
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
  '';

  meta = {
    description = "Linux desktop music player from the future";
    mainProgram = "tauon";
    homepage = "https://tauonmusicbox.rocks/";
    changelog = "https://github.com/Taiko2k/Tauon/releases/tag/v${version}";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ jansol ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
