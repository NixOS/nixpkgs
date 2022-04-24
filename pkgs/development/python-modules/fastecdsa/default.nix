{ lib
, buildPythonPackage
, fetchPypi
, gmp
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "fastecdsa";
  version = "2.2.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "269bdb0f618b38f8f6aec9d23d23db518046c3cee01a954fa6aa7322a1a7db8f";
  };

  buildInputs = [ gmp ];

  checkInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # skip tests which require being online to download test vectors
    "fastecdsa/tests/test_wycheproof_vectors.py"
    "fastecdsa/tests/test_rfc6979_ecdsa.py"
  ];

  # skip tests for now, they fail with
  # ImportError: cannot import name '_ecdsa' from 'fastecdsa'
  # but the installed package works just fine
  doCheck = false;

  pythonImportsCheck = [ "fastecdsa" ];

  meta = with lib; {
    description = "Fast elliptic curve digital signatures";
    homepage = "https://github.com/AntonKueltz/fastecdsa";
    license = licenses.unlicense;
    maintainers = with maintainers; [ prusnak ];
  };
}
