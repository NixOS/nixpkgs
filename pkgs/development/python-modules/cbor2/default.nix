{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, hypothesis
, pytestCheckHook
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "cbor2";
  version = "5.5.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+eGS9GGp+PYILfKMA1sAbRU5BCE9yGQL7Ypy1yu8lHU=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  nativeCheckInputs = [
    hypothesis
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
    changelog = "https://github.com/agronholm/cbor2/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
