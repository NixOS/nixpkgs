{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  setuptools,

  # nativeBuildInputs
  pkg-config,

  # buildInputs
  libraw,

  # dependencies
  numpy,

  # tests
  imageio,
  pytestCheckHook,
  scikit-image,
}:

buildPythonPackage rec {
  pname = "rawpy";
  version = "0.23.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "letmaik";
    repo = "rawpy";
    rev = "refs/tags/v${version}";
    hash = "sha256-s7/YbD5Jy9Jzry817djG63Zs4It8b1S95qmcJgPYGZQ=";
  };

  build-system = [
    cython
    numpy
    setuptools
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libraw
  ];

  dependencies = [
    numpy
  ];

  env = {
    RAWPY_USE_SYSTEM_LIBRAW = 1;
  };

  pythonImportsCheck = [
    "rawpy"
    "rawpy._rawpy"
  ];

  # Delete the source files to load the library from the installed folder instead of the source files
  preCheck = ''
    rm -rf rawpy
  '';

  nativeCheckInputs = [
    imageio
    pytestCheckHook
    scikit-image
  ];

  disabledTests = [
    # rawpy._rawpy.LibRawFileUnsupportedError: b'Unsupported file format or not RAW file'
    "testFoveonFileOpenAndPostProcess"
    "testThumbExtractBitmap"
  ];

  meta = {
    description = "RAW image processing for Python, a wrapper for libraw";
    homepage = "https://github.com/letmaik/rawpy";
    license = with lib.licenses; [
      lgpl21Only
      mit
    ];
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
