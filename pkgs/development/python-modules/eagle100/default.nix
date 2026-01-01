{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "eagle100";
  version = "0.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-eyYY1x8IjIfUx5OiaOomiWunsO1++seFwXlI/iKDDLw=";
  };

  propagatedBuildInputs = [ requests ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "eagle100" ];

<<<<<<< HEAD
  meta = {
    description = "Python library for interacting with Rainforest EAGLE devices";
    homepage = "https://github.com/hastarin/eagle100";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Python library for interacting with Rainforest EAGLE devices";
    homepage = "https://github.com/hastarin/eagle100";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
