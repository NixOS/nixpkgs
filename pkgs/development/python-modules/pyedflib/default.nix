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
  version = "0.1.42";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "holgern";
    repo = "pyedflib";
    tag = "v${version}";
    hash = "sha256-KbySCsDjiS94U012KASRgHR2fuX090HlKUuPgsLC+xQ=";
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
    changelog = "https://github.com/holgern/pyedflib/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
