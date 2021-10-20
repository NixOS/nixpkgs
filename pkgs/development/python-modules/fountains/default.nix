{ lib
, buildPythonPackage
, fetchPypi
, bitlist
}:

buildPythonPackage rec {
  pname = "fountains";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fbf4e2cb11d60d3bafca5bb7c01c254d08a5541ed7ddfe00ef975eb173fb75a4";
  };

  propagatedBuildInputs = [
    bitlist
  ];

  # Project has no test
  doCheck = false;

  pythonImportsCheck = [ "fountains" ];

  meta = with lib; {
    description = "Python library for generating and embedding data for unit testing";
    homepage = "https://github.com/reity/fountains";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
