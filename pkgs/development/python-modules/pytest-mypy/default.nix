{
  lib,
  attrs,
  buildPythonPackage,
  fetchPypi,
  filelock,
  pytest,
  mypy,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
  pytest-xdist,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytest-mypy";
  version = "1.1.0";
  pyproject = true;

  src = fetchPypi {
    pname = "pytest_mypy";
    inherit (finalAttrs) version;
    hash = "sha256-ufQjfAMR7sUHxImG3eLXdvOZyY/bktrlyT+WwZvK4OQ=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  buildInputs = [ pytest ];

  dependencies = [
    attrs
    mypy
    filelock
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
    mypy
  ];

  pythonImportsCheck = [ "pytest_mypy" ];

  meta = {
    description = "Mypy static type checker plugin for Pytest";
    homepage = "https://github.com/dbader/pytest-mypy";
    changelog = "https://github.com/realpython/pytest-mypy/releases/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
})
