{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pydot,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-sugar,
  pytest-mock,
  pytest-benchmark,
  pytest-asyncio,
  django,
  pytest-django,
}:

buildPythonPackage rec {
  pname = "python-statemachine";
  version = "2.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fgmacedo";
    repo = "python-statemachine";
    rev = "refs/tags/v${version}";
    hash = "sha256-ykC0jTPgCikHx+oKSqv+tKtlWZDQ1KBqf6G4qJelcQc=";
  };

  build-system = [
    poetry-core
  ];

  optional-dependencies = {
    diagrams = [ pydot ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    pytest-sugar
    pytest-mock
    pytest-benchmark
    pytest-asyncio
    django
    pytest-django
    pydot
  ];

  pythonImportsCheck = [ "statemachine" ];

  meta = {
    description = "Python Finite State Machines made easy";
    homepage = "https://github.com/fgmacedo/python-statemachine";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
