{ lib
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "plumbum";
  version = "1.6.3";
  name = "${pname}-${version}";

  checkInputs = [ pytest ];

  # No tests in archive
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0249e708459f1b05627a7ca8787622c234e4db495a532acbbd1f1f17f28c7320";
  };
}