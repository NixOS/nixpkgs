{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  packaging,
  pytest,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-rerunfailures";
  version = "16.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = "pytest-rerunfailures";
    tag = version;
    hash = "sha256-p81k2gT9YZ0Ic696B4nZZS05Tfbzc7qyNzwl++QmKAI=";
  };

  build-system = [ setuptools ];

  buildInputs = [ pytest ];

  dependencies = [ packaging ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Pytest plugin to re-run tests to eliminate flaky failures";
    homepage = "https://github.com/pytest-dev/pytest-rerunfailures";
    changelog = "https://github.com/pytest-dev/pytest-rerunfailures/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ das-g ];
  };
}
