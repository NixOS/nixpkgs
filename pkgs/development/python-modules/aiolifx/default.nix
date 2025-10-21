{
  lib,
  async-timeout,
  bitstring,
  buildPythonPackage,
  click,
  fetchPypi,
  ifaddr,
  inquirerpy,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aiolifx";
  version = "1.2.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-h82KPrHcWUUrQFyMy3fY6BmQFA5a4DFJdhJ6zRnKMsc=";
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

  meta = {
    description = "Module for local communication with LIFX devices over a LAN";
    homepage = "https://github.com/aiolifx/aiolifx";
    changelog = "https://github.com/aiolifx/aiolifx/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ netixx ];
    mainProgram = "aiolifx";
  };
}
