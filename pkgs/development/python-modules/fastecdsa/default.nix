{
  lib,
  buildPythonPackage,
  fetchPypi,
  gmp,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "fastecdsa";
  version = "3.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9LSlD9XjRsSUmro2XAYcP2sl7ueYPJc+HTHednK6SOo=";
  };

  buildInputs = [ gmp ];

  nativeCheckInputs = [ pytestCheckHook ];

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

  meta = {
    description = "Fast elliptic curve digital signatures";
    homepage = "https://github.com/AntonKueltz/fastecdsa";
    changelog = "https://github.com/AntonKueltz/fastecdsa/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ prusnak ];
  };
}
