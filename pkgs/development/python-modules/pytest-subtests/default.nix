{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  attrs,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-subtests";
  version = "0.14.2";
  pyproject = true;

  src = fetchPypi {
    pname = "pytest_subtests";
    inherit version;
    hash = "sha256-cVSoZl/VKO5wp20AIWpE0TncPJyDUhoPd597CtT4AN4=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [ attrs ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_subtests" ];

  meta = {
    description = "Pytest plugin for unittest subTest() support and subtests fixture";
    homepage = "https://github.com/pytest-dev/pytest-subtests";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
