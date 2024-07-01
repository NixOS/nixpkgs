{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  msgpack,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "fluent-logger";
  version = "0.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fluent";
    repo = "fluent-logger-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-PfyjJZT5K/IMsyyWNZdh/CZf+uZHeJGfhyAPuu0IhJk=";
  };

  build-system = [ hatchling ];

  dependencies = [ msgpack ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "fluent"
    "fluent.event"
    "fluent.handler"
    "fluent.sender"
  ];

  meta = with lib; {
    description = "Structured logger for Fluentd (Python)";
    homepage = "https://github.com/fluent/fluent-logger-python";
    license = licenses.asl20;
  };
}
