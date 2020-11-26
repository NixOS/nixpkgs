{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  version = "0.1.1";
  pname = "pyro-api";

  src = fetchPypi {
    inherit version pname;
    sha256 = "0rhd7p61pf2vvflbdixp7sygblvvl9qbqavxj27910lr79vl4fdz";
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
