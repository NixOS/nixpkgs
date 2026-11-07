{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  filelock,
  mako,
  pybind11,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "cppimport";
  version = "26.04.17";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tbenthompson";
    repo = "cppimport";
    tag = finalAttrs.version;
    hash = "sha256-uhKBqNij2F/3jmVsfFq6/0bPmgHrPNAA6zarh0Cjua4=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  # setuptools builds the extensions at run time.
  dependencies = [
    filelock
    mako
    pybind11
    setuptools
  ];

  pythonImportsCheck = [ "cppimport" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Import C or C++ files directly from Python";
    homepage = "https://github.com/tbenthompson/cppimport";
    changelog = "https://github.com/tbenthompson/cppimport/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ connorbaker ];
  };
})
