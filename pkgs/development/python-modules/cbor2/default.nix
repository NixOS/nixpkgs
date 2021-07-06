{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pytest-cov
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "cbor2";
  version = "5.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a7926f7244b08c413f1a4fa71a81aa256771c75bdf1a4fd77308547a2d63dd48";
  };

  nativeBuildInputs = [ setuptools-scm ];

  checkInputs = [
    pytest-cov
    pytestCheckHook
  ];

  # https://github.com/agronholm/cbor2/issues/99
  disabledTests = lib.optionals stdenv.is32bit [
    "test_huge_truncated_bytes"
    "test_huge_truncated_string"
  ];

  pythonImportsCheck = [ "cbor2" ];

  meta = with lib; {
    description = "Python CBOR (de)serializer with extensive tag support";
    homepage = "https://github.com/agronholm/cbor2";
    license = licenses.mit;
    maintainers = with maintainers; [ taneb ];
  };
}
