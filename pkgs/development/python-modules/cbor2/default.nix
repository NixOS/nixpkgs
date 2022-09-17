{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "cbor2";
  version = "5.4.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Yrhjxe5s7UAyr+lI88FITzdVUJldO4SYFFI3/ijlRsI=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov" ""
  '';

  # https://github.com/agronholm/cbor2/issues/99
  disabledTests = lib.optionals stdenv.is32bit [
    "test_huge_truncated_bytes"
    "test_huge_truncated_string"
  ];

  pythonImportsCheck = [
    "cbor2"
  ];

  meta = with lib; {
    description = "Python CBOR (de)serializer with extensive tag support";
    homepage = "https://github.com/agronholm/cbor2";
    license = licenses.mit;
    maintainers = with maintainers; [ taneb ];
  };
}
