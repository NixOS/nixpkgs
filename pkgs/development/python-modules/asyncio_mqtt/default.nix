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
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c1b3bea68a35c83d290a89903079ffb311106195cd56867e201633a1ee1cad0c";
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
