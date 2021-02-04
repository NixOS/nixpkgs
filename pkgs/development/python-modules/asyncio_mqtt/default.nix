{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, async_generator
, paho-mqtt
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "asyncio_mqtt";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0hwfgww1ywhjvkpnvafbk2hxlqkrngfdz0sx5amzw68srzazvl6g";
  };

  propagatedBuildInputs = [
    paho-mqtt
  ] ++ lib.optional (pythonOlder "3.7") async_generator;

  doCheck = false; # no tests

  pythonImportsCheck = [ "asyncio_mqtt" ];

  meta = with lib; {
    description = "Idomatic asyncio wrapper around paho-mqtt";
    homepage = "https://github.com/sbtinstruments/asyncio-mqtt";
    license = licenses.bsd3;
    changelog = "https://github.com/sbtinstruments/asyncio-mqtt/blob/master/CHANGELOG.md";
    maintainers = with maintainers; [ hexa ];
  };
}
