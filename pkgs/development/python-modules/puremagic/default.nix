{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "puremagic";
  version = "1.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-jAuuwImSExc2KjD6yi6WeMkdXpfOAE3Gp8HGaeBUeDg=";
  };

  # test data not included on pypi
  doCheck = false;

  pythonImportsCheck = [ "puremagic" ];

  meta = with lib; {
    description = "Pure python implementation of magic file detection";
    license = licenses.mit;
    homepage = "https://github.com/cdgriffith/puremagic";
    maintainers = with maintainers; [ globin ];
  };
}
