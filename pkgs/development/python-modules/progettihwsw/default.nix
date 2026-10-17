{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  lxml,
}:

buildPythonPackage rec {
  pname = "progettihwsw";
  version = "0.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ardaseremet";
    repo = "progettihwsw";
    tag = "v${version}";
    hash = "sha256-MSHb9zRfrsQ7Gh+31Ky7pH8dwOqM17tbqpBELSif60U=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    lxml
  ];

  # Package has no tests
  doCheck = false;

  pythonImportsCheck = [ "ProgettiHWSW" ];

  meta = {
    description = "Controls ProgettiHWSW relay boards";
    homepage = "https://github.com/ardaseremet/progettihwsw";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
