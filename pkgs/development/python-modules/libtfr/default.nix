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
  version = "2.1.10";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3iW9LevxZwzxxFmXoIayVA/zJPzq6i7jMFwVfZLttDY=";
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
