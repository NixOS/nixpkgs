{ lib, buildPythonPackage, fetchPypi, pytest, pytestcov, setuptools_scm }:

buildPythonPackage rec {
  pname = "cbor2";
  version = "4.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bp9l3wdj0wm15xlmlcwbgv6hc6vcfx39nssikj8fkwnd7d1bdhp";
  };

  nativeBuildInputs = [ setuptools_scm ];
  checkInputs = [ pytest pytestcov ];

  checkPhase = "pytest";

  meta = with lib; {
    description = "Pure Python CBOR (de)serializer with extensive tag support";
    homepage = https://github.com/agronholm/cbor2;
    license = licenses.mit;
    maintainers = with maintainers; [ taneb ];
  };
}
