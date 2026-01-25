{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  influxdb,
  jsonpath-ng,
  paho-mqtt,
  py-expression-eval,
  pyaml,
  pycron,
  pytestCheckHook,
  schema,
  setuptools,
}:

buildPythonPackage rec {
  pname = "mqtt2influxdb";
  version = "2.0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hardwario";
    repo = "bch-mqtt2influxdb";
    tag = "v${version}";
    hash = "sha256-DS1k3JcTUK0yXRkJSFMeIZHSXpiIgSXJPZb3+72Wqko=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "find_version('mqtt2influxdb', '__init__.py')," "'${version}',"
  '';

  build-system = [ setuptools ];

  dependencies = [
    influxdb
    jsonpath-ng
    paho-mqtt
    py-expression-eval
    pyaml
    pycron
    schema
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mqtt2influxdb" ];

  enabledTestPaths = [ "tests/test.py" ];

  meta = {
    description = "Flexible MQTT to InfluxDB Bridge";
    homepage = "https://github.com/hardwario/bch-mqtt2influxdb";
    changelog = "https://github.com/hardwario/bch-mqtt2influxdb/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cynerd ];
    mainProgram = "mqtt2influxdb";
  };
}
