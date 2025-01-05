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
  version = "0.11.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fluent";
    repo = "fluent-logger-python";
    tag = "v${version}";
    hash = "sha256-i6S5S2ZUwC5gQPdVjefUXrKj43iLIqxd8tdXbMBJNnA=";
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
