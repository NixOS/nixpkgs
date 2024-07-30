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
  schema,
}:
buildPythonPackage rec {
  pname = "mqtt2influxdb";
  version = "1.5.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "hardwario";
    repo = "bch-mqtt2influxdb";
    rev = "v${version}";
    sha256 = "YDgMoxnH4vCCa7b857U6iVBhYLxk8ZjytGziryn24bg=";
  };

  propagatedBuildInputs = [
    influxdb
    jsonpath-ng
    paho-mqtt
    py-expression-eval
    pyaml
    pycron
    schema
  ];

  pythonImportsCheck = [ "mqtt2influxdb" ];

  meta = with lib; {
    homepage = "https://github.com/hardwario/bch-mqtt2influxdb";
    description = "Flexible MQTT to InfluxDB Bridge";
    mainProgram = "mqtt2influxdb";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [ cynerd ];
  };
}
