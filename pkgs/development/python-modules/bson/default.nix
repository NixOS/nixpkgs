{
  lib,
  buildPythonPackage,
  fetchPypi,
  python-dateutil,
  six,
}:

buildPythonPackage rec {
  pname = "bson";
  version = "0.5.10";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1lEbKrBRE5qRI8GE3hoEInJiFzrVk0KdIeRD1kYtZZA=";
  };

  propagatedBuildInputs = [
    python-dateutil
    six
  ];

  # 0.5.10 was not tagged, https://github.com/py-bson/bson/issues/108
  doCheck = false;

  pythonImportsCheck = [ "bson" ];

  meta = with lib; {
    description = "BSON codec for Python";
    homepage = "https://github.com/py-bson/bson";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
