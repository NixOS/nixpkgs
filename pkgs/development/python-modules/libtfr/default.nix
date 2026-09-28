{
  lib,
  fetchPypi,
  buildPythonPackage,

  # build-system
  setuptools_80,
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
  version = "2.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+fq5cpBiY5AJYDoxEAoQG8iEoEDfhHqChBAky1jKD/g=";
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
    setuptools_80
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
