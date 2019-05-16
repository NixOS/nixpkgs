{ lib, buildPythonPackage, fetchPypi, smmap2 }:

buildPythonPackage rec {
  pname = "gitdb2";
  version = "2.0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "83361131a1836661a155172932a13c08bda2db3674e4caa32368aa6eb02f38c2";
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
