{ lib
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "plumbum";
  version = "1.6.5";
  name = "${pname}-${version}";

  checkInputs = [ pytest ];

  # No tests in archive
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "d8abb059bb62beb6c99db08d3598167abaeeab53eaf218f91e74bae471a24bee";
  };
}