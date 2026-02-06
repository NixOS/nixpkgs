{
  stdenv,
  lib,
  replaceVars,
  fetchFromGitHub,
  buildPythonPackage,
  python,
  pkg-config,
  setuptools,
  cython,
  ninja,
  meson-python,
  pyproject-metadata,
  nix-update-script,

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
  numpy,
  astroid,

  pygame-gui,
}:

buildPythonPackage rec {
  pname = "pygame-ce";
  version = "2.5.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pygame-community";
    repo = "pygame-ce";
    tag = version;
    hash = "sha256-0DNvAs1E6OhN6wTvbMCDt9YAEFoBZp1r7hI4GSnJUl8=";
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
        ]) buildInputs
      );
      buildinputs_lib = builtins.toJSON (
        builtins.concatMap (dep: [
          "${lib.getLib dep}/"
          "${lib.getLib dep}/lib"
        ]) buildInputs
      );
    })

    # https://github.com/pygame-community/pygame-ce/pull/3680#issuecomment-3796052119
    ./skip-failing-tests.patch
  ];

  postPatch = ''
    # "pyproject-metadata!=0.9.1" was pinned due to https://github.com/pygame-community/pygame-ce/pull/3395
    # cython was pinned to fix windows build hangs (pygame-community/pygame-ce/pull/3015)
    substituteInPlace pyproject.toml \
      --replace-fail '"pyproject-metadata!=0.9.1",' '"pyproject-metadata",' \
      --replace-fail '"meson<=1.9.1",' '"meson",' \
      --replace-fail '"meson-python<=0.18.0",' '"meson-python",' \
      --replace-fail '"ninja<=1.13.0",' "" \
      --replace-fail '"astroid<4.0.0",' "" \
      --replace-fail '"cython<=3.1.4",' '"cython",' \
      --replace-fail '"sphinx<=8.2.3",' "" \
      --replace-fail '"sphinx-autoapi<=3.6.0",' ""
    substituteInPlace buildconfig/config_{unix,darwin}.py \
      --replace-fail 'from distutils' 'from setuptools._distutils'
    substituteInPlace src_py/sysfont.py \
      --replace-fail 'path="fc-list"' 'path="${fontconfig}/bin/fc-list"' \
      --replace-fail /usr/X11/bin/fc-list ${fontconfig}/bin/fc-list
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # flaky
    rm test/system_test.py
    substituteInPlace test/meson.build \
      --replace-fail "'system_test.py'," ""
  '';

  nativeBuildInputs = [
    pkg-config
    cython
    setuptools
    ninja
    meson-python
    pyproject-metadata
  ];

  buildInputs = [
    freetype
    libX11
    libjpeg
    libpng
    portmidi
    SDL2
    (SDL2_image.override { enableSTB = false; })
    SDL2_mixer
    SDL2_ttf
    astroid
  ];

  nativeCheckInputs = [
    numpy
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
    export HOME=$(mktemp -d)
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

  passthru.updateScript = nix-update-script { };

  passthru.tests = {
    inherit pygame-gui;
  };

  meta = {
    description = "Pygame Community Edition (CE) - library for multimedia application built on SDL";
    homepage = "https://pyga.me/";
    changelog = "https://github.com/pygame-community/pygame-ce/releases/tag/${src.tag}";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ lib.maintainers.pbsds ];
    platforms = lib.platforms.unix;
  };
}
