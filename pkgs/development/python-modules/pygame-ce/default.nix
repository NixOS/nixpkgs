{
  stdenv,
  lib,
  substituteAll,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,
  python,
  pkg-config,
  setuptools,
  cython,

  AppKit,
  fontconfig,
  freetype,
  libjpeg,
  libpng,
  libX11,
  portmidi,
  SDL2,
  SDL2_image,
  SDL2_mixer,
  SDL2_ttf,
}:

buildPythonPackage rec {
  pname = "pygame-ce";
  version = "2.4.1";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "pygame-community";
    repo = "pygame-ce";
    rev = "refs/tags/${version}";
    hash = "sha256-4Ky+QEUsQ0odcwEETk0yGECs7CcJQthhavboOnMDvF8=";
    # Unicode file cause different checksums on HFS+ vs. other filesystems
    postFetch = "rm -rf $out/docs/reST";
  };

  patches = [
    (substituteAll {
      src = ./fix-dependency-finding.patch;
      buildinputs_include = builtins.toJSON (
        builtins.concatMap (dep: [
          "${lib.getDev dep}/"
          "${lib.getDev dep}/include"
          "${lib.getDev dep}/include/SDL2"
        ]) buildInputs
      );
      buildinputs_lib = builtins.toJSON (
        builtins.concatMap (dep: [
          "${lib.getLib dep}/"
          "${lib.getLib dep}/lib"
        ]) buildInputs
      );
    })
    # Skip tests that should be disabled without video driver
    ./skip-surface-tests.patch
  ];

  postPatch =
    ''
      substituteInPlace buildconfig/config_{unix,darwin}.py \
        --replace-fail 'from distutils' 'from setuptools._distutils'
      substituteInPlace src_py/sysfont.py \
        --replace-fail 'path="fc-list"' 'path="${fontconfig}/bin/fc-list"' \
        --replace-fail /usr/X11/bin/fc-list ${fontconfig}/bin/fc-list
    ''
    + lib.optionalString stdenv.isDarwin ''
      # flaky
      rm test/system_test.py
    '';

  nativeBuildInputs = [
    pkg-config
    cython
    setuptools
  ];

  buildInputs = [
    freetype
    libX11
    libjpeg
    libpng
    portmidi
    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_ttf
  ] ++ lib.optionals stdenv.isDarwin [ AppKit ];

  preConfigure = ''
    ${python.pythonOnBuildForHost.interpreter} buildconfig/config.py
  '';

  env =
    {
      SDL_CONFIG = "${SDL2.dev}/bin/sdl2-config";
    }
    // lib.optionalAttrs stdenv.cc.isClang {
      NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-function-pointer-types";
    };

  preCheck = ''
    export HOME=$(mktemp -d)
    # No audio or video device in test environment
    export SDL_VIDEODRIVER=dummy
    export SDL_AUDIODRIVER=disk
  '';

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m pygame.tests -v --exclude opengl,timing --time_out 300
    runHook postCheck
  '';

  pythonImportsCheck = [ "pygame" ];

  meta = with lib; {
    description = "Pygame Community Edition (CE) - library for multimedia application built on SDL";
    homepage = "https://pyga.me/";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ pbsds ];
    platforms = platforms.unix;
  };
}
