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
  version = "1.0.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-E3UxNTqss3urpMTwhLhIoAnBekGOIyFy0+sOj3mGlss=";
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
    mainProgram = "aiolifx";
    homepage = "https://github.com/frawau/aiolifx";
    changelog = "https://github.com/frawau/aiolifx/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ netixx ];
  };
}
