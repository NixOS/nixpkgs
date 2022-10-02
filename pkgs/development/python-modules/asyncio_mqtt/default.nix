{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, async_generator
, paho-mqtt
}:

buildPythonPackage rec {
  pname = "asyncio-mqtt";
  version = "0.12.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "asyncio_mqtt";
    inherit version;
    sha256 = "sha256-bb+FpF+U0m50ZUEWgK2jlHtQVG6YII1dUuegp+16fDg=";
  };

  propagatedBuildInputs = [
    paho-mqtt
  ] ++ lib.optional (pythonOlder "3.7") [
    async_generator
  ];

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
