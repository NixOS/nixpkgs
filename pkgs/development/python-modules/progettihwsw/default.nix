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
  version = "0.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ardaseremet";
    repo = "progettihwsw";
    tag = version;
    hash = "sha256-9dpZyQ7i3WNdDVyEBLz4bJcWF1Ap7SH089PXWYI6UOA=";
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
