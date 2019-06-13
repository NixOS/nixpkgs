{ buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "plumbum";
  version = "1.6.7";

  checkInputs = [ pytest ];

  # No tests in archive
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "d143f079bfb60b11e9bec09a49695ce2e55ce5ca0246877bdb0818ab7c7fc312";
  };
}