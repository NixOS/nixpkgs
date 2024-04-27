{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "parts";
  version = "1.7.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TbcFgWKKgHXFyi1NqwVy1ITGHESb4ZusivOpFWazN1s=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "parts"
  ];

  meta = with lib; {
    description = "Library for common list functions related to partitioning lists";
    homepage = "https://github.com/lapets/parts";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
