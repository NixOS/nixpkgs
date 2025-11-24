{
  buildPythonPackage,
  fetchPypi,
  httpx,
  lib,
  linode-cli,
  pytest,
  pytest-asyncio,
  setuptools,
}:

buildPythonPackage rec {
  pname = "linode-metadata";
  version = "0.3.2";

  src = fetchPypi {
    pname = "linode_metadata";
    inherit version;
    hash = "sha256-5/tHYwP/acIdyCW1vu+zKSPywatHWwxcUNbC59TIcBc=";
  };

  pyproject = true;

  dependencies = [
    httpx
    setuptools
  ];

  checkInputs = [
    pytest
    pytest-asyncio
  ];

  pythonImportsCheck = [ "linode_metadata" ];

  meta = {
    description = "Python package for interacting with the Linode Metadata Service";
    downloadPage = "https://pypi.org/project/linode-metadata/";
    homepage = "https://github.com/linode/py-metadata";
    changelog = "https://github.com/linode/py-metadata/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = linode-cli.meta.maintainers;
  };
}
