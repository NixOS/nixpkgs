{
  lib,
  buildPythonPackage,
  cython,
  fetchPypi,
  numpy,
  oldest-supported-numpy,
  packaging,
  pot,
  pytestCheckHook,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyemd";
  version = "2.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FZaflENcK+mOajakkwfINm49/BpnASrMMG6SyQtQP+U=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeBuildInputs = [
    cython
    numpy
    oldest-supported-numpy
    packaging
  ];

  dependencies = [
    numpy
    pot
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # Broken with Numpy 2.x, https://github.com/wmayner/pyemd/issues/68
    "test_emd_samples_2"
    "test_emd_samples_3"
  ];

  meta = {
    description = "Python wrapper for Ofir Pele and Michael Werman's implementation of the Earth Mover's Distance";
    homepage = "https://github.com/wmayner/pyemd";
    changelog = "https://github.com/wmayner/pyemd/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
