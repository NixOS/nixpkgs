{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,
  poetry-dynamic-versioning,

  # dependencies
  pytest,
  ruff,

  # tests
  pytestCheckHook,
  pytest-mock,
}:

buildPythonPackage rec {
  pname = "pytest-ruff";
  version = "0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "businho";
    repo = "pytest-ruff";
    tag = "v${version}";
    hash = "sha256-fwtubbTRvPMSGhylP3H5zhIwHdeWeTbvxZY5doM+tvw=";
  };

  build-system = [
    poetry-core
    poetry-dynamic-versioning
  ];

  dependencies = [
    pytest
    ruff
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ];

  pythonImportsCheck = [ "pytest_ruff" ];

  meta = {
    description = "A pytest plugin to run ruff";
    homepage = "https://github.com/businho/pytest-ruff";
    changelog = "https://github.com/businho/pytest-ruff/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ baloo ];
  };
}
