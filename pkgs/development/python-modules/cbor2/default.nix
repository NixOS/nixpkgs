{ lib, buildPythonPackage, fetchPypi, pytest, pytestcov, setuptools_scm }:

buildPythonPackage rec {
  pname = "cbor2";
  version = "5.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "91759bd0ee5ef0d4fa24144dfa551670730baeca8cf2fff1cc59f734ecd21de6";
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
