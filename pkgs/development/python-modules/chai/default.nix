{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "chai";
  version = "1.1.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "016kf3irrclpkpvcm7q0gmkfibq7jgy30a9v73pp42bq9h9a32bl";
  };

  meta = with stdenv.lib; {
    description = "Mocking, stubbing and spying framework for python";
  };
}
