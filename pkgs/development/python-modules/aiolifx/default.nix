{ lib
, async-timeout
, click
, fetchPypi
, buildPythonPackage
, pythonOlder
, ifaddr
, inquirerpy
, bitstring
, setuptools
}:

buildPythonPackage rec {
  pname = "aiolifx";
  version = "1.0.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-r42M7aqKKLdGgRaCym44M1nvu0vTGK7ricBp/AsbFRk=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    async-timeout
    bitstring
    click
    ifaddr
    inquirerpy
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "aiolifx"
  ];

  meta = with lib; {
    description = "Module for local communication with LIFX devices over a LAN";
    homepage = "https://github.com/frawau/aiolifx";
    changelog = "https://github.com/frawau/aiolifx/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ netixx ];
  };
}
