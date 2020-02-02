{ lib, buildPythonPackage, fetchPypi, pytest, pytestcov, setuptools_scm }:

buildPythonPackage rec {
  pname = "cbor2";
  version = "5.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fid6li95jx9c3v83v8c2c8lb03jgirkk9mjmck30yxcwmlxp6a2";
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
