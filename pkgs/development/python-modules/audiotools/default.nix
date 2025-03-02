{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  stdenv,
  AudioToolbox,
  AudioUnit,
  CoreServices,
  pkg-config,
  libmpg123,
  lame,
  twolame,
  libopus,
  opusfile,
  libvorbis,
  libcdio,
  libcdio-paranoia,
}:

buildPythonPackage {
  pname = "audiotools";
  version = "3.1.1-unstable-2020-07-29";
  pyproject = true;

  build-system = [
    setuptools
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      libmpg123 # MP2/MP3 decoding
      lame # MP3 encoding
      twolame # MP2 encoding
      opusfile # opus decoding
      libopus # opus encoding
      libvorbis # ogg encoding/decoding
      libcdio # CD reading
      libcdio-paranoia # CD reading
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      AudioToolbox
      AudioUnit
      CoreServices
    ];

  preConfigure = ''
    # needed because mp3lame is not reported in pkg-config
    substituteInPlace setup.cfg \
      --replace-fail "mp3lame:           probe" "mp3lame:           yes"
  '';

  # needed for the PY_SSIZE_T_CLEAN macro
  src = fetchFromGitHub {
    owner = "tuffy";
    repo = "python-audio-tools";
    rev = "de55488dc982e3f6375cde2d0c2ea6aad1b1c31c";
    hash = "sha256-iRakeV4Sg4oU0JtiA0O3jnmLJt99d89Hg6v9onUaSnw=";
  };

  meta = with lib; {
    description = "Utilities and Python modules for handling audio";
    homepage = "https://audiotools.sourceforge.net/";
    license = licenses.gpl2Plus;
    maintainers = [ ];
  };
}
