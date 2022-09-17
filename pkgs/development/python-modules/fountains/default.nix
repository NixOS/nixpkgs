{ lib
, buildPythonPackage
, fetchPypi
, bitlist
, pythonOlder
}:

buildPythonPackage rec {
  pname = "fountains";
  version = "2.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9ASOgqkE1vwCKGAZXEJaHoABMXomIWTGv3jAsNssdsU=";
  };

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
