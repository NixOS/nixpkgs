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
    hash = "sha256-2v9jyicZ+9aYqhD2RJPEsx+2eHeo6Nu4CQ6cA6GxqeQ=";
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
