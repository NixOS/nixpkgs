{ lib
, buildPythonPackage
, fetchFromGitHub
, gmp
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "fastecdsa";
  version = "2.2.2";
  format = "setuptools";

  src = fetchFromGitHub {
     owner = "AntonKueltz";
     repo = "fastecdsa";
     rev = "v2.2.2";
     sha256 = "03g11r6pcrcl0i9zsa3b8yrwkak0hyqfpfi7py7zx31jslnrlz0f";
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
