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
  version = "5.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1jga5wj3kalf6zj5gyrmy6kwmxxkld52mvcgxc5gb5dmdhpl7gx8";
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
