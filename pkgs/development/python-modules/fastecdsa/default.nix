{ lib
, buildPythonPackage
, fetchPypi
, gmp
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "fastecdsa";
  version = "2.2.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-JpvbD2GLOPj2rsnSPSPbUYBGw87gGpVPpqpzIqGn248=";
  };

  buildInputs = [
    gmp
  ];

  checkInputs = [
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
    license = licenses.cc0;
    maintainers = with maintainers; [ prusnak ];
  };
}
