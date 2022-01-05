{ lib
, buildPythonPackage
, fetchPypi
, bitlist
}:

buildPythonPackage rec {
  pname = "fountains";
  version = "1.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-bea8EXw3b0CibhEREdY4FZouiiXP4y+UbbDXed7Ltwo=";
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
