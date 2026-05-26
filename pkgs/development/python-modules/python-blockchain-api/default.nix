{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-blockchain-api";
  version = "0.0.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JC/FWkSq+Rc/XX39RQgLBnlncuRRumFNArODNJDzAHw=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  pythonImportsCheck = [ "pyblockchain" ];

  # Package has no tests
  doCheck = false;

  meta = {
    description = "Python API for interacting with blockchain.info";
    homepage = "https://github.com/nkgilley/python-blockchain-api";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
