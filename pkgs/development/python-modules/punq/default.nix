{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  setuptools,

  # dependencies
  typing-extensions,

  # tests
  attrs,
  expects,
  pytestCheckHook,
  sqlalchemy,
}:

buildPythonPackage rec {
  pname = "punq";
  version = "0.8.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "bobthemighty";
    repo = "punq";
    tag = "v${version}";
    hash = "sha256-HlgPsHaRnAT80/J6/v0oLhNzOCxsDVg/lwztJWLsg+I=";
  };

  build-system = [ setuptools ];

  dependencies = [ typing-extensions ];

  nativeCheckInputs = [
    attrs
    expects
    pytestCheckHook
    # `punq/__init__.py` doctests import sqlalchemy (run via --doctest-modules)
    sqlalchemy
  ];

  pythonImportsCheck = [ "punq" ];

  meta = {
    changelog = "https://github.com/bobthemighty/punq/releases/tag/v${version}";
    description = "Unintrusive dependency injection library for Python";
    homepage = "https://github.com/bobthemighty/punq";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sesav ];
  };
}
