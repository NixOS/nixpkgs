{ lib
, buildPythonPackage
, fetchPypi
, bitlist
}:

buildPythonPackage rec {
  pname = "fountains";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-e4WCO/CS7LBYUziKPuCQIOHEHUlnKE5vDbOsqC8SrA8=";
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
