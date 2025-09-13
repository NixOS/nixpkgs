{
  lib,
  fetchPypi,
  buildPythonPackage,

  # build-system
  setuptools,
  pkg-config,
  cython,
  pkgconfig,

  # Dependencies
  numpy,
  fftw,
  lapack,

  # Check
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "libtfr";
  version = "2.1.9";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GxRjkQ6ng2wNONRit8ZsCwWsVlXy//7taeU6np/5aU0=";
  };

  nativeBuildInputs = [
    pkg-config
    cython
  ];

  buildInputs = [
    fftw
    lapack
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
    pkgconfig
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "libtfr" ];

  meta = {
    description = "fast multitaper conventional and reassignment spectrograms";
    homepage = "https://melizalab.github.io/libtfr/";
    downloadPage = "https://github.com/melizalab/libtfr";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      RossSmyth
    ];
  };
}
