{ lib, buildPythonPackage, fetchPypi, smmap }:

buildPythonPackage rec {
  pname = "gitdb";
  version = "0.6.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0n4n2c7rxph9vs2l6xlafyda5x1mdr8xy16r9s3jwnh3pqkvrsx3";
  };

  propagatedBuildInputs = [ smmap ];

  # Bunch of tests fail because they need an actual git repo
  doCheck = false;

  meta = {
    description = "Git Object Database";
    maintainers = [ ];
    homepage = https://github.com/gitpython-developers/gitdb;
    license = lib.licenses.bsd3;
  };
}
