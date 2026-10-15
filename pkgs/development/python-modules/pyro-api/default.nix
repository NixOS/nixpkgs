{
  buildPythonPackage,
  fetchPypi,
  lib,
}:

buildPythonPackage rec {
  version = "0.1.2";
  format = "setuptools";
  pname = "pyro-api";

  src = fetchPypi {
    inherit version pname;
    hash = "sha256-obkA2VgKocL6s7Ejq3/zNBN0TafF9EC9Sq3E1A0U2SA=";
  };

  pythonImportsCheck = [ "pyroapi" ];

  # tests require pyro-ppl which depends on this package
  doCheck = false;

  meta = {
    description = "Generic API for dispatch to Pyro backends";
    homepage = "http://pyro.ai";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ georgewhewell ];
  };
}
