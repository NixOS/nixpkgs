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
  mtdev,
  SDL2,
  SDL2_image,
  SDL2_ttf,
  SDL2_mixer,
  libcxx,
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

  build-system = [
    setuptools
    cython
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      SDL2
      SDL2_image
      SDL2_ttf
      SDL2_mixer
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
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

  KIVY_NO_CONFIG = 1;
  KIVY_NO_ARGS = 1;
  KIVY_NO_FILELOG = 1;
  # prefer pkg-config over hardcoded framework paths
  USE_OSX_FRAMEWORKS = 0;
  # work around python distutils compiling C++ with $CC (see issue #26709)
  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.cc.isGNU [
      "-Wno-error=incompatible-pointer-types"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      "-I${lib.getDev libcxx}/include/c++/v1"
    ]
  );

  postPatch =
    ''
      substituteInPlace pyproject.toml \
        --replace-fail "setuptools~=69.2.0" "setuptools" \
        --replace-fail "wheel~=0.44.0" "wheel"
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      substituteInPlace kivy/lib/mtdev.py \
        --replace-fail "LoadLibrary('libmtdev.so.1')" "LoadLibrary('${mtdev}/lib/libmtdev.so.1')"
    '';

  /*
    We cannot run tests as Kivy tries to import itself before being fully
    installed.
  */
  doCheck = false;
  pythonImportsCheck = [ "kivy" ];

  meta = with lib; {
    description = "Library for rapid development of hardware-accelerated multitouch applications";
    homepage = "https://pypi.python.org/pypi/kivy";
    license = licenses.mit;
    maintainers = with maintainers; [ risson ];
  };
}
