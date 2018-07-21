{ buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "plumbum";
  version = "1.6.6";

  checkInputs = [ pytest ];

  # No tests in archive
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "d179b90a9927f91427a28c1bac2864c61342cb43ef39aa7324c7c9a96bcc23eb";
  };
}