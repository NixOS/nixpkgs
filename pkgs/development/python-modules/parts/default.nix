{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "parts";
  version = "1.3.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-NrhNpWyzqwn1bNnuqmcyKcUED0A4v7VJE4ZlTHFafJY=";
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
