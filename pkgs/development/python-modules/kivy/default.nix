{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pkg-config,
  cython,
  docutils,
  setuptools,
  kivy-garden,
  libGL,
  libx11,
  mtdev,
  python3,
  SDL2,
  SDL2_image,
  SDL2_ttf,
  SDL2_mixer,
  angle,
  withGstreamer ? true,
  gst_all_1,
  pygments,
  requests,
  filetype,
}:

buildPythonPackage (finalAttrs: {
  pname = "kivy";
  version = "2.3.1-unstable-2026-07-11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kivy";
    repo = "kivy";
    rev = "d8e642fec15894ce338b0c9773c3f58b41b75f09";
    hash = "sha256-i+4qsCIWOddfkw4fseHyTZRj29cdPX84uaPMORE6Gp4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools~=82.0.0" "setuptools" \
      --replace-fail "wheel~=0.47.0" "wheel" \
      --replace-fail "cython>=0.29.1,<=3.2.0" "cython" \
      --replace-fail "packaging~=26.0" packaging
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace kivy/lib/mtdev.py \
      --replace-fail "LoadLibrary('libmtdev.so.1')" "LoadLibrary('${lib.getLib mtdev}/lib/libmtdev.so.1')"
  '';

  build-system = [
    setuptools
    cython
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    SDL2
    SDL2_image
    SDL2_ttf
    SDL2_mixer
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libGL
    libx11
    mtdev
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    angle
  ]
  ++ lib.optionals withGstreamer (
    with gst_all_1;
    [
      # NOTE: The degree to which gstreamer actually works is unclear
      gstreamer
      gst-plugins-base
      gst-plugins-good
      gst-plugins-bad
    ]
  );

  dependencies = [
    kivy-garden
    docutils
    pygments
    requests
    filetype
  ];

  env = {
    KIVY_NO_CONFIG = 1;
    KIVY_NO_ARGS = 1;
    KIVY_NO_FILELOG = 1;

    # prefer pkg-config over hardcoded framework paths
    USE_OSX_FRAMEWORKS = 0;

    # work around python distutils compiling C++ with $CC (see issue #26709)
    NIX_CFLAGS_COMPILE = toString (
      lib.optionals stdenv.cc.isGNU [
        "-Wno-error=incompatible-pointer-types"
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
        # fatal error: 'Python.h' file not found
        "-I${python3}/include/${python3.libPrefix}"
        "-I${lib.getInclude stdenv.cc.libcxx}/include/c++/v1"
      ]
    );
  }
  // lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    KIVY_ANGLE_INCLUDE_DIR = "${lib.getInclude angle}/include";
    KIVY_ANGLE_LIB_DIR = "${lib.getLib angle}/lib";
  };

  /*
    We cannot run tests as Kivy tries to import itself before being fully
    installed.
  */
  doCheck = false;
  pythonImportsCheck = [ "kivy" ];

  meta = {
    description = "Library for rapid development of hardware-accelerated multitouch applications";
    homepage = "https://github.com/kivy/kivy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ risson ];
  };
})
