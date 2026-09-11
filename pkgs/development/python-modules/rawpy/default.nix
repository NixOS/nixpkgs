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

buildPythonPackage (finalAttrs: {
  pname = "rawpy";
  version = "0.28.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "letmaik";
    repo = "rawpy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zmI5MPMg5rcQK0LCX1TqO1J78R8PXTSRMxM+SksNvJI=";
  };

  # cmake is only needed to build libraw when `RAWPY_USE_SYSTEM_LIBRAW` is disabled
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"cmake",' ""
  '';

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
    "testCropSizeSigma"
    "testFoveonFileOpenAndPostProcess"
    "testThumbExtractBitmap"
  ];

  meta = {
    description = "RAW image processing for Python, a wrapper for libraw";
    homepage = "https://github.com/letmaik/rawpy";
    changelog = "https://github.com/letmaik/rawpy/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      lgpl21Only
      mit
    ];
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
