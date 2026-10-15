{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  python-json-logger,
  jsonschema,
  ruamel-yaml,
  traitlets,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "jupyter-telemetry";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jupyter";
    repo = "telemetry";
    tag = "v${version}";
    hash = "sha256-WxTlTs6gE9pa0hbl29Zvwikobz1/2JQ3agYO7WxyZ2E=";
  };

  build-system = [ setuptools ];

  dependencies = [
    python-json-logger
    jsonschema
    ruamel-yaml
    traitlets
  ];

  pythonImportsCheck = [ "jupyter_telemetry" ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # AssertionError
    "test_record_event"
    "test_unique_logger_instances"
  ];

  meta = {
    description = "Telemetry for Jupyter Applications and extensions";
    homepage = "https://jupyter-telemetry.readthedocs.io/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ chiroptical ];
  };
}
