{
  lib,
  async-timeout,
  bitstring,
  buildPythonPackage,
  click,
  fetchPypi,
  ifaddr,
  inquirerpy,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aiolifx";
  version = "1.1.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7T7nHmnK1ZLoIgi6e8VVrq6NVAmL7tVi+F/6G3Ayh2Q=";
  };

  build-system = [ setuptools ];

  dependencies = [
    async-timeout
    bitstring
    click
    ifaddr
    inquirerpy
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "aiolifx" ];

  meta = with lib; {
    description = "Module for local communication with LIFX devices over a LAN";
    homepage = "https://github.com/aiolifx/aiolifx";
    changelog = "https://github.com/aiolifx/aiolifx/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ netixx ];
    mainProgram = "aiolifx";
  };
}
