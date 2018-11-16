{ lib, buildPythonPackage, fetchPypi, smmap2 }:

buildPythonPackage rec {
  pname = "gitdb2";
  version = "2.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bb4c85b8a58531c51373c89f92163b92f30f81369605a67cd52d1fc21246c044";
  };

  propagatedBuildInputs = [ smmap2 ];

  # Bunch of tests fail because they need an actual git repo
  doCheck = false;

  meta = {
    description = "Git Object Database";
    maintainers = [ ];
    homepage = https://github.com/gitpython-developers/gitdb;
    license = lib.licenses.bsd3;
  };
}
