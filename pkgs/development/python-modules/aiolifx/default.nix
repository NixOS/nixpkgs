{
  lib,
  async-timeout,
  bitstring,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  ifaddr,
  inquirerpy,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aiolifx";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aiolifx";
    repo = "aiolifx";
    tag = version;
    hash = "sha256-9FTsY/VFfzLlDEjF8ueBQxr30YasdQwei1/KfHiXwMo=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [ "click" ];

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
