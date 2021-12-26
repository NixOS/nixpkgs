{ buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "plumbum";
  version = "1.7.2";

  checkInputs = [ pytest ];

  # No tests in archive
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0d1bf908076bbd0484d16412479cb97d6843069ee19f99e267e11dd980040523";
  };
}
