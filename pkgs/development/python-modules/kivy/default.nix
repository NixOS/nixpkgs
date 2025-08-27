{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  cython,
  docutils,
  setuptools,
  kivy-garden,
  libGL,
  libX11,
  mtdev,
  SDL2,
  SDL2_image,
  SDL2_ttf,
  SDL2_mixer,
  withGstreamer ? true,
  gst_all_1,
  pygments,
  requests,
  filetype,
}:

buildPythonPackage rec {
  pname = "kivy";
  version = "2.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kivy";
    repo = "kivy";
    tag = version;
    hash = "sha256-q8BoF/pUTW2GMKBhNsqWDBto5+nASanWifS9AcNRc8Q=";
  };

  patches = [
    # Fix compat with newer Cython
    (fetchpatch {
      name = "0001-kivy-Remove-old-Python-2-long.patch";
      url = "https://github.com/kivy/kivy/commit/5a1b27d7d3bdee6cedb55440bfae9c4e66fb3c68.patch";
      hash = "sha256-GDNYL8dC1Rh4KJ8oPiIjegOJGzRQ1CsgWQeAvx9+Rc8=";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools~=69.2.0" "setuptools" \
      --replace-fail "wheel~=0.44.0" "wheel" \
      --replace-fail "cython>=0.29.1,<=3.0.11" "cython" \
      --replace-fail "packaging~=24.0" packaging
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
    libX11
    mtdev
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
        "-I${lib.getInclude stdenv.cc.libcxx}/include/c++/v1"
      ]
    );
  };

  /*
    We cannot run tests as Kivy tries to import itself before being fully
    installed.
  */
  doCheck = false;
  pythonImportsCheck = [ "kivy" ];

  meta = {
    changelog = "https://github.com/kivy/kivy/releases/tag/${src.tag}";
    description = "Library for rapid development of hardware-accelerated multitouch applications";
    homepage = "https://github.com/kivy/kivy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ risson ];
  };
}
