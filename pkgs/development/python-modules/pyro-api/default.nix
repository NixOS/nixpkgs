{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  version = "0.1.2";
  format = "setuptools";
  pname = "pyro-api";

  src = fetchPypi {
    inherit version pname;
    sha256 = "a1b900d9580aa1c2fab3b123ab7ff33413744da7c5f440bd4aadc4d40d14d920";
  };

  pythonImportsCheck = [ "pyroapi" ];

  # tests require pyro-ppl which depends on this package
  doCheck = false;

  meta = {
    description = "Generic API for dispatch to Pyro backends.";
    homepage = "http://pyro.ai";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ georgewhewell ];
  };
}
