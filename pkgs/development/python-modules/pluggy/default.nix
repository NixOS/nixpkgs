{ buildPythonPackage
, lib
, fetchFromGitHub
, setuptools-scm
, pythonOlder
, importlib-metadata
, callPackage
}:

buildPythonPackage rec {
  pname = "pluggy";
  version = "1.3.0";

  disabled = pythonOlder "3.8";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = "pluggy";
    rev = "refs/tags/${version}";
    hash = "sha256-jLasnqmATIOoheGu90Wo1+iTCwslYzNOKckqHIZDJec=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  # To prevent infinite recursion with pytest
  doCheck = false;
  passthru.tests = {
    pytest = callPackage ./tests.nix { };
  };

  meta = {
    changelog = "https://github.com/pytest-dev/pluggy/blob/${src.rev}/CHANGELOG.rst";
    description = "Plugin and hook calling mechanisms for Python";
    homepage = "https://github.com/pytest-dev/pluggy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
