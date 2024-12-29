{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  cryptography,
  onetimepad,
}:

buildPythonPackage rec {
  pname = "pysqlitecipher";
  version = "0.22";

  disabled = pythonOlder "3.6";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "daff63ca2719fbd698aa10f64493c4b31fb67877a8e8dbb8090e9c03a1b1a9e4";
  };

  propagatedBuildInputs = [
    cryptography
    onetimepad
  ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [ "pysqlitecipher" ];

  meta = {
    description = "Lightweight and easy to use sqlite wrapper with built-in encryption system";
    homepage = "https://github.com/harshnative/pysqlitecipher";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
