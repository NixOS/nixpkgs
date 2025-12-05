{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  replaceVars,
  fontconfig,
  python,

  # build-system
  cython,
  setuptools,

  # nativeBuildInputs
  SDL2,
  pkg-config,

  # buildInputs
  freetype,
  libjpeg,
  libpng,
  libX11,
  portmidi,
  SDL2_image,
  SDL2_mixer,
  SDL2_ttf,
}:

buildPythonPackage rec {
  pname = "pygame";
  version = "2.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pygame";
    repo = "pygame";
    tag = version;
    # Unicode file names lead to different checksums on HFS+ vs. other
    # filesystems because of unicode normalisation. The documentation
    # has such files and will be removed.
    hash = "sha256-paSDF0oPogq0g0HSDRagGu0OfsqIku6q4GGAMveGntk=";
    postFetch = "rm -rf $out/docs/reST";
  };

  patches = [
    # Patch pygame's dependency resolution to let it find build inputs
    (replaceVars ./fix-dependency-finding.patch {
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

    # mixer queue test returns busy queue when it shouldn't
    ./skip-mixer-test.patch

    # Can be removed with the next SDL3 bump.
    ./skip-rle-tests.patch

    # https://github.com/pygame/pygame/pull/4497
    ./0001-Use-SDL_HasSurfaceRLE-when-available.patch
    ./0002-Don-t-assume-that-touch-devices-support-get_num_fing.patch

    # https://github.com/pygame/pygame/pull/4651
    ./0001-Use-SDL_AllocFormat-instead-of-creating-it-manually.patch
  ];

  postPatch = ''
    substituteInPlace src_py/sysfont.py \
      --replace-fail 'path="fc-list"' 'path="${fontconfig}/bin/fc-list"' \
      --replace-fail /usr/X11/bin/fc-list ${fontconfig}/bin/fc-list
  '';

  build-system = [
    cython
    setuptools
  ];

  nativeBuildInputs = [
    SDL2
    pkg-config
  ];

  buildInputs = [
    freetype
    libjpeg
    libpng
    libX11
    portmidi
    SDL2
    (SDL2_image.override { enableSTB = false; })
    SDL2_mixer
    SDL2_ttf
  ];

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
    # traceback for segfaults
    export PYTHONFAULTHANDLER=1

    ${python.interpreter} -m pygame.tests -v \
      --exclude opengl,timing \
      --time_out 300

    runHook postCheck
  '';
  pythonImportsCheck = [ "pygame" ];

  meta = {
    description = "Python library for games";
    homepage = "https://www.pygame.org/";
    changelog = "https://github.com/pygame/pygame/releases/tag/${src.tag}";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ emilytrau ];
    platforms = lib.platforms.unix;
  };
}
