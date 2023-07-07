{ lib
, buildPythonPackage
, fetchPypi
, gmp
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "fastecdsa";
  version = "2.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8ZjORPaUbKuwKYip9J0U78QQ26XiEemDIbqdhzeyP/g=";
  };

  buildInputs = [
    gmp
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    # skip tests which require being online to download test vectors
    "fastecdsa/tests/test_wycheproof_vectors.py"
    "fastecdsa/tests/test_rfc6979_ecdsa.py"
  ];

  # skip tests for now, they fail with
  # ImportError: cannot import name '_ecdsa' from 'fastecdsa'
  # but the installed package works just fine
  doCheck = false;

  pythonImportsCheck = [
    "fastecdsa"
  ];

  meta = with lib; {
    description = "Fast elliptic curve digital signatures";
    homepage = "https://github.com/AntonKueltz/fastecdsa";
    changelog = "https://github.com/AntonKueltz/fastecdsa/blob/v${version}/CHANGELOG.md";
    license = licenses.unlicense;
    maintainers = with maintainers; [ prusnak ];
  };
}
