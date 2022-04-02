{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "puremagic";
  version = "1.12";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-jAuuwImSExc2KjD6yi6WeMkdXpfOAE3Gp8HGaeBUeDg=";
  };

  # test data not included on pypi
  doCheck = false;

  pythonImportsCheck = [
    "puremagic"
  ];

  meta = with lib; {
    description = "Implementation of magic file detection";
    homepage = "https://github.com/cdgriffith/puremagic";
    license = licenses.mit;
    maintainers = with maintainers; [ globin ];
  };
}
