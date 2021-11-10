{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, async_generator
, paho-mqtt
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "asyncio-mqtt";
  version = "0.11.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "asyncio_mqtt";
    inherit version;
    sha256 = "sha256-uJown3bNA+pLJlorJcCjpMMFosX94gt/2tLAjIkuXLA=";
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
