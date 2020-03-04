{ buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "plumbum";
  version = "1.6.8";

  checkInputs = [ pytest ];

  # No tests in archive
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "14mbyvc1y25lr72n1zh9ym5ngify7zdr57lxahidq03ycpwz4wc5";
  };
}