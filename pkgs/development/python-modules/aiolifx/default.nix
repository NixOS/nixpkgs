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

buildPythonPackage (finalAttrs: {
  pname = "aiolifx";
  version = "1.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aiolifx";
    repo = "aiolifx";
    tag = finalAttrs.version;
    hash = "sha256-v2001UY12HTi1pgugfRQSUg1R6uZAfVpwCASZZW9S0o=";
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
    changelog = "https://github.com/aiolifx/aiolifx/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ netixx ];
    mainProgram = "aiolifx";
  };
})
