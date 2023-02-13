{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, setuptools-scm
, wheel
, py
, pytest
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-forked";
  version = "1.6.0";

  disabled = pythonOlder "3.7";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = "pytest-forked";
    rev = "refs/tags/v${version}";
    hash = "sha256-owkGwF5WQ17/CXwTsIYJ2AgktekRB4qhtsDxR0LCI/k=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    py
  ];

  nativeCheckInputs = [
    py
    pytestCheckHook
  ];

  setupHook = ./setup-hook.sh;

  meta = {
    changelog = "https://github.com/pytest-dev/pytest-forked/blob/${src.rev}/CHANGELOG.rst";
    description = "Run tests in isolated forked subprocesses";
    homepage = "https://github.com/pytest-dev/pytest-forked";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
