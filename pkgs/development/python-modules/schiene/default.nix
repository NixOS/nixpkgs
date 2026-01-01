{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "schiene";
  version = "0.26";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sCaVrHqQZwAZDXIjh4Rg9ZT/EQSbrOPdSyT8oofCsmA=";
  };

  propagatedBuildInputs = [
    requests
    beautifulsoup4
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "schiene" ];

<<<<<<< HEAD
  meta = {
    description = "Python library for interacting with Bahn.de";
    homepage = "https://github.com/kennell/schiene";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Python library for interacting with Bahn.de";
    homepage = "https://github.com/kennell/schiene";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
