{ lib, buildPythonPackage, fetchPypi, smmap2 }:

buildPythonPackage rec {
  pname = "gitdb2";
  version = "2.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02azg62mr99b7cllyjrly77np3vw32y8nrxpa2xjapiyaga2j3mn";
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
