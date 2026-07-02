{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  replaceVars,
  python,

  # build-system
  cython,
  meson-python,
  ninja,
  pyproject-metadata,
  setuptools,
  sphinx,
  sphinx-autoapi,

  # nativeBuildInputs
  astroid,
  pkg-config,

  # buildInputs
  fontconfig,
  freetype,
  libjpeg,
  libpng,
  libx11,
  portmidi,
  SDL2,
  SDL2_image,
  SDL2_mixer,
  SDL2_ttf,

  # tests
  numpy,
  writableTmpDirAsHomeHook,

  # passthru
  nix-update-script,
  pygame-gui,
}:

buildPythonPackage (finalAttrs: {
  pname = "pygame-ce";
  version = "2.5.7";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pygame-community";
    repo = "pygame-ce";
    tag = finalAttrs.version;
    hash = "sha256-Yjs2SLgPVMOy8DCS+Pfk0fs0G//sY20jfGQNJ5rN58Q=";
    # Unicode files cause different checksums on HFS+ vs. other filesystems
    postFetch = "rm -rf $out/docs/reST";
  };

  patches = [
    (replaceVars ./fix-dependency-finding.patch {
      buildinputs_include = builtins.toJSON (
        builtins.concatMap (dep: [
          "${lib.getDev dep}/"
          "${lib.getDev dep}/include"
          "${lib.getDev dep}/include/SDL2"
        ]) finalAttrs.buildInputs
      );
      buildinputs_lib = builtins.toJSON (
        builtins.concatMap (dep: [
          "${lib.getLib dep}/"
          "${lib.getLib dep}/lib"
        ]) finalAttrs.buildInputs
      );
    })
  ];

  postPatch =
    # "pyproject-metadata!=0.9.1" was pinned due to https://github.com/pygame-community/pygame-ce/pull/3395
    # cython was pinned to fix windows build hangs (pygame-community/pygame-ce/pull/3015)
    ''
      substituteInPlace pyproject.toml \
        --replace-fail "meson-python<=0.18.0" "meson-python" \
        --replace-fail "meson<=1.10.0" "meson" \
        --replace-fail "ninja<=1.13.0" "ninja" \
        --replace-fail "cython<=3.2.4" "cython" \
        --replace-fail "sphinx<=8.2.3" "sphinx" \
        --replace-fail "astroid<4.0.0" "astroid" \
        --replace-fail "sphinx-autoapi<=3.6.0" "sphinx-autoapi" \
        --replace-fail "pyproject-metadata!=0.9.1" "pyproject-metadata"
    ''
    # distutils now lives under setuptools._distutils
    + ''
      substituteInPlace buildconfig/config_{unix,darwin}.py \
        --replace-fail 'from distutils' 'from setuptools._distutils'
    ''
    # Inject the path to fc-list
    + ''
      substituteInPlace src_py/sysfont.py \
        --replace-fail \
          'path="fc-list"' \
          'path="${lib.getExe' fontconfig "fc-list"}"' \
        --replace-fail \
          '/usr/X11/bin/fc-list' \
          '${lib.getExe' fontconfig "fc-list"}'
    ''
    # flaky
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      rm test/system_test.py
      substituteInPlace test/meson.build \
        --replace-fail "'system_test.py'," ""
    '';

  build-system = [
    astroid
    cython
    meson-python
    ninja
    pyproject-metadata
    setuptools
    sphinx
    sphinx-autoapi
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    freetype
    libx11
    libjpeg
    libpng
    portmidi
    SDL2
    (SDL2_image.override { enableSTB = false; })
    SDL2_mixer
    SDL2_ttf
  ];

  nativeCheckInputs = [
    numpy
    writableTmpDirAsHomeHook
  ];

  preConfigure = ''
    ${python.pythonOnBuildForHost.interpreter} -m buildconfig.config
  '';

  env = {
    SDL_CONFIG = lib.getExe' (lib.getDev SDL2) "sdl2-config";
  }
  // lib.optionalAttrs stdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-function-pointer-types";
  };

  preCheck = ''
    # No audio or video device in test environment
    export SDL_VIDEODRIVER=dummy
    export SDL_AUDIODRIVER=disk
    # traceback for segfaults
    export PYTHONFAULTHANDLER=1
  '';

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m pygame.tests -v --exclude opengl,timing --time_out 300
    runHook postCheck
  '';

  pythonImportsCheck = [
    "pygame"
    "pygame.camera"
    "pygame.colordict"
    "pygame.cursors"
    "pygame.freetype"
    "pygame.ftfont"
    "pygame.locals"
    "pygame.midi"
    "pygame.pkgdata"
    "pygame.sndarray" # requires numpy
    "pygame.sprite"
    "pygame.surfarray"
    "pygame.sysfont"
    "pygame.version"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      inherit pygame-gui;
    };
  };

  meta = {
    description = "Pygame Community Edition (CE) - library for multimedia application built on SDL";
    homepage = "https://pyga.me/";
    changelog = "https://github.com/pygame-community/pygame-ce/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ lib.maintainers.pbsds ];
    platforms = lib.platforms.unix;
  };
})
