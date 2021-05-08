{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pytest-cov
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "cbor2";
  version = "5.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a33aa2e5534fd74401ac95686886e655e3b2ce6383b3f958199b6e70a87c94bf";
  };

  nativeBuildInputs = [ setuptools_scm ];

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
