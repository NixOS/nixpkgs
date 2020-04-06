{ lib, buildPythonPackage, fetchPypi, pytest, pytestcov, setuptools_scm }:

buildPythonPackage rec {
  pname = "cbor2";
  version = "5.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ai1i0wydxfbdakqnrlpgdk4l2ps7gw0r9nihv9p2jgyqbl13kj3";
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
