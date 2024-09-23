{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  path,
  tox,
  virtualenv,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "jaraco-envs";
  version = "2.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jaraco";
    repo = "jaraco.envs";
    rev = "refs/tags/v${version}";
    hash = "sha256-yRMX0H6yWN8TiO/LGAr4HyrVS8ZhBjuR885/+UQscP0=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    path
    tox
    virtualenv
  ];

  pythonImportsCheck = [ "jaraco.envs" ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # requires networking
    "jaraco/envs.py"
  ];

  meta = {
    changelog = "https://github.com/jaraco/jaraco.envs/blob/${src.rev}/NEWS.rst";
    description = "Classes for orchestrating Python (virtual) environments";
    homepage = "https://github.com/jaraco/jaraco.envs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
