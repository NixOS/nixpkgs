{
  lib,
  buildPythonPackage,
  fetchPypi,
  pycryptodome,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "brelpy";
  version = "0.0.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MYWSKYd7emHZfY+W/UweQtTg62GSUMybpecL9BR8dhg=";
  };

  propagatedBuildInputs = [ pycryptodome ];

  # Source not tagged and PyPI releases don't contain tests
  doCheck = false;

  pythonImportsCheck = [ "brelpy" ];

<<<<<<< HEAD
  meta = {
    description = "Python to communicate with the Brel hubs";
    homepage = "https://gitlab.com/rogiervandergeer/brelpy";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Python to communicate with the Brel hubs";
    homepage = "https://gitlab.com/rogiervandergeer/brelpy";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
