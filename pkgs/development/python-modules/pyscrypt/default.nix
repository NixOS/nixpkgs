{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,
}:

buildPythonPackage rec {
  pname = "pyscrypt";
  version = "1.6.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1sd5pd5fpcdnpp4h58kdnvkf0s3afh4ssfqky2ap6z0gy6ax3zds";
  };

  checkPhase = ''
    ${python.interpreter} tests/run-tests-hash.py
  '';

  meta = {
    homepage = "https://github.com/ricmoo/pyscrypt/";
    description = "Pure-Python implementation of Scrypt PBKDF and scrypt file format library";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ valodim ];
  };
}
