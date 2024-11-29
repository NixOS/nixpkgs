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
  version = "1.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hardwario";
    repo = "bch-mqtt2influxdb";
    rev = "refs/tags/v${version}";
    hash = "sha256-YDgMoxnH4vCCa7b857U6iVBhYLxk8ZjytGziryn24bg=";
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

  pytestFlagsArray = [ "tests/test.py" ];

  meta = with lib; {
    description = "Flexible MQTT to InfluxDB Bridge";
    homepage = "https://github.com/hardwario/bch-mqtt2influxdb";
    changelog = "https://github.com/hardwario/bch-mqtt2influxdb/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ cynerd ];
    mainProgram = "mqtt2influxdb";
  };
}
