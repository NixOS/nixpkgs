{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, async_generator
, paho-mqtt
}:

buildPythonPackage rec {
  pname = "asyncio-mqtt";
  version = "0.11.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "asyncio_mqtt";
    inherit version;
    sha256 = "6fc2ec01288a6ee0df88fa5a2f18439c4f8a7fe926339e4ecdf874e8da4ce45a";
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
