{ lib, buildPythonPackage, fetchPypi, smmap2 }:

buildPythonPackage rec {
  pname = "gitdb2";
  version = "2.0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1b6df1433567a51a4a9c1a5a0de977aa351a405cc56d7d35f3388bad1f630350";
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
