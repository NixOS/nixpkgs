{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder

# build-system
, setuptools
, setuptools-scm

# tests
, hypothesis
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "cbor2";
  version = "5.5.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+eGS9GGp+PYILfKMA1sAbRU5BCE9yGQL7Ypy1yu8lHU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov" ""
  '';

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  pythonImportsCheck = [
    "cbor2"
  ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  # https://github.com/agronholm/cbor2/issues/99
  disabledTests = lib.optionals stdenv.is32bit [
    "test_huge_truncated_bytes"
    "test_huge_truncated_string"
  ];

  meta = with lib; {
    changelog = "https://github.com/agronholm/cbor2/releases/tag/${version}";
    description = "Python CBOR (de)serializer with extensive tag support";
    homepage = "https://github.com/agronholm/cbor2";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
