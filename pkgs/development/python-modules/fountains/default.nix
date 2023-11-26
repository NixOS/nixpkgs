{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, wheel
, bitlist
, pythonOlder
}:

buildPythonPackage rec {
  pname = "fountains";
  version = "2.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MhOQ4pemxmjfp7Uy5hLA8i8BBI5QbvD4EjEcKMM/u3I=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    bitlist
  ];

  # Module has no test
  doCheck = false;

  pythonImportsCheck = [
    "fountains"
  ];

  meta = with lib; {
    description = "Python library for generating and embedding data for unit testing";
    homepage = "https://github.com/reity/fountains";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
