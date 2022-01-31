{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "parts";
  version = "1.2.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6463d5c49142d14029196a6a781b57bc98ba5b3d93244f4ed637f534d08129c1";
  };

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "parts"
  ];

  meta = with lib; {
    description = "Python library for common list functions related to partitioning lists";
    homepage = "https://github.com/lapets/parts";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
