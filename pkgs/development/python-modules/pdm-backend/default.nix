{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub

# propagates
, importlib-metadata

# tests
, editables
, git
, pytestCheckHook
, setuptools
}:

buildPythonPackage rec {
  pname = "pdm-backend";
  version = "2.1.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pdm-project";
    repo = "pdm-backend";
    rev = "refs/tags/${version}";
    hash = "sha256-asW5L9jS++9ovq7WFh0rU7aB7R2rwi5ce80Hxk9NrI4=";
  };

  env.PDM_BUILD_SCM_VERSION = version;

  propagatedBuildInputs = lib.optionals (pythonOlder "3.10") [
    importlib-metadata
  ];

  pythonImportsCheck = [
    "pdm.backend"
  ];

  nativeCheckInputs = [
    editables
    git
    pytestCheckHook
    setuptools
  ];

  preCheck = ''
    unset PDM_BUILD_SCM_VERSION
  '';

  setupHook = ./setup-hook.sh;

  meta = with lib; {
    homepage = "https://github.com/pdm-project/pdm-backend";
    changelog = "https://github.com/pdm-project/pdm-backend/releases/tag/${version}";
    description = "Yet another PEP 517 backend.";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
