{
  stdenv,
  lib,
  substituteAll,
  fetchpatch,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,

  # build-system
  cython,
  setuptools,
  pkg-config,

  # native dependencies
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

  # tests
  python,
}:

buildPythonPackage rec {
  pname = "pygame";
  version = "2.5.2";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
    # Unicode file names lead to different checksums on HFS+ vs. other
    # filesystems because of unicode normalisation. The documentation
    # has such files and will be removed.
    hash = "sha256-+gRv3Rim+2aL2uhPPGfVD0QDgB013lTf6wPx8rOwgXg=";
    postFetch = "rm -rf $out/docs/reST";
  };

  patches = [
    # Patch pygame's dependency resolution to let it find build inputs
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

    # removes distutils unbreaking py312, part of https://github.com/pygame/pygame/pull/4211
    (fetchpatch {
      name = "remove-distutils.patch";
      url = "https://github.com/pygame/pygame/commit/6038e7d6583a7a25fcc6e15387cf6240e427e5a7.patch";
      hash = "sha256-HxcYjjhsu/Y9HiK9xDvY4X5dgWPP4XFLxdYGXC6tdWM=";
    })
  ];

  postPatch = ''
    substituteInPlace src_py/sysfont.py \
      --replace-fail 'path="fc-list"' 'path="${fontconfig}/bin/fc-list"' \
      --replace-fail /usr/X11/bin/fc-list ${fontconfig}/bin/fc-list
  '';

  nativeBuildInputs = [
    cython
    pkg-config
    SDL2
    setuptools
  ];

  buildInputs = [
    freetype
    libjpeg
    libpng
    libX11
    portmidi
    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_ttf
  ] ++ lib.optionals stdenv.isDarwin [ AppKit ];

  preConfigure = ''
    ${python.pythonOnBuildForHost.interpreter} buildconfig/config.py
  '';

  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-function-pointer-types";
  };

  checkPhase = ''
    runHook preCheck

    # No audio or video device in test environment
    export SDL_VIDEODRIVER=dummy
    export SDL_AUDIODRIVER=disk

    ${python.interpreter} -m pygame.tests -v --exclude opengl,timing --time_out 300

    runHook postCheck
  '';
  pythonImportsCheck = [ "pygame" ];

  meta = with lib; {
    description = "Python library for games";
    homepage = "https://www.pygame.org/";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ emilytrau ];
    platforms = platforms.unix;
  };
}
