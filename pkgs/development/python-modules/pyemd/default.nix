{
  lib,
  buildPythonPackage,
  cython,
  fetchPypi,
  numpy,
  oldest-supported-numpy,
  packaging,
  pytestCheckHook,
  pythonOlder,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyemd";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tCta57LRWx1N7mOBDqeYo5IX6Kdre0nA62OoTg/ZAP4=";
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

  dependencies = [ numpy ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # Broken with Numpy 2.x, https://github.com/wmayner/pyemd/issues/68
    "test_emd_samples_2"
    "test_emd_samples_3"
  ];

  meta = with lib; {
    description = "Python wrapper for Ofir Pele and Michael Werman's implementation of the Earth Mover's Distance";
    homepage = "https://github.com/wmayner/pyemd";
    changelog = "https://github.com/wmayner/pyemd/releases/tag/${version}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
