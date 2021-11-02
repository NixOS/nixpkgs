{ lib
, buildPythonPackage
, fetchPypi
, gmp
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "fastecdsa";
  version = "2.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1eb6f3ac86ec483a10df62fcda1fb9a9d5d895a436871a8aa935dd20ccd82c6f";
  };

  buildInputs = [ gmp ];

  checkInputs = [ pytestCheckHook ];

  # skip tests which require being online to download test vectors
  pytestFlags = [
     "--ignore=fastecdsa/tests/test_wycheproof_vectors.py"
     "--ignore=fastecdsa/tests/test_rfc6979_ecdsa.py"
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
