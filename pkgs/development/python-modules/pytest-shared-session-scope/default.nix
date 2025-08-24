{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  filelock,
  pytest,
  typing-extensions,
  polars,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-shared-session-scope";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "StefanBRas";
    repo = "pytest-shared-session-scope";
    tag = "v${version}";
    hash = "sha256-/26iwaV6E15TWrObIvXE4AipEboe1gv6WYu4BndPtUs=";
  };

  build-system = [ hatchling ];

  dependencies = [
    filelock
    pytest
    typing-extensions
  ];

  nativeCheckInputs = [
    polars
    pytest-xdist
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pytest_shared_session_scope" ];

  meta = {
    changelog = "https://github.com/StefanBRas/pytest-shared-session-scope/blob/${src.tag}/CHANGELOG.md";
    description = "Pytest session-scoped fixture that works with xdist";
    homepage = "https://pypi.org/project/pytest-shared-session-scope/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
