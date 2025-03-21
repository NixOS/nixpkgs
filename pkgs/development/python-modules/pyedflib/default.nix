{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  numpy,
  setuptools,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyedflib";
  version = "0.1.40";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "holgern";
    repo = "pyedflib";
    tag = "v${version}";
    hash = "sha256-FWEd1Y883LPsPdzbjR6+emsYBMBrM33/jR8p1aIWmV4=";
  };

  build-system = [
    cython
    numpy
    setuptools
  ];

  pythonImportsCheck = [
    "pyedflib"
  ];

  # Otherwise, the module is imported from source and lacks the compiled artifacts
  # By moving to the pyedflib directory, python imports the installed package instead of the module
  # from the local files
  preCheck = ''
    cd pyedflib
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Python library to read/write EDF+/BDF+ files based on EDFlib";
    homepage = "https://github.com/holgern/pyedflib";
    changelog = "https://github.com/holgern/pyedflib/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
