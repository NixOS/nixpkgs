{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  requests,
}:

buildPythonPackage rec {
  pname = "hydrus-api";
  version = "5.3.0";
  pyproject = true;

  src = fetchPypi {
    pname = "hydrus_api";
    inherit version;
    hash = "sha256-Xq27pMVj2JkcHLvFzVDKL9KNOjTxZ3yH5+RVcVMzKJc=";
  };

  build-system = [ poetry-core ];

  dependencies = [ requests ];

  pythonImportsCheck = [ "hydrus_api" ];

  # There are no unit tests
  doCheck = false;

  meta = {
    description = "Python module implementing the Hydrus API";
    homepage = "https://gitlab.com/cryzed/hydrus-api";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ dandellion ];
  };
}
