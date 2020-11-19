{ lib, buildPythonPackage, fetchPypi, pytest, pytestcov, setuptools_scm }:

buildPythonPackage rec {
  pname = "cbor2";
  version = "5.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a33aa2e5534fd74401ac95686886e655e3b2ce6383b3f958199b6e70a87c94bf";
  };

  nativeBuildInputs = [ setuptools_scm ];
  checkInputs = [ pytest pytestcov ];

  checkPhase = "pytest";

  meta = with lib; {
    description = "Pure Python CBOR (de)serializer with extensive tag support";
    homepage = "https://github.com/agronholm/cbor2";
    license = licenses.mit;
    maintainers = with maintainers; [ taneb ];
  };
}
