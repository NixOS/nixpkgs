{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  async-property,
  pytest-asyncio,
  setuptools,
  websockets,
}:

buildPythonPackage rec {
  pname = "neohubapi";
  version = "3.1";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "neohubapi";
    repo = "neohubapi";
    rev = "v${version}";
    hash = "sha256-niRDUiKtpDq6mTlSln2tMrUDN2WRaRRbQQk3gaRIAUc=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    async-property
    websockets
  ];

  nativeCheckInputs = [
    pytest-asyncio
  ];

  pythonImportsCheck = [
    "neohubapi"
  ];

  meta = {
    description = "Async library to communicate with Heatmiser NeoHub 2 API";
    homepage = "https://gitlab.com/neohubapi/neohubapi/";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ ];
  };
}
