{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  types-awscrt,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "botocore-stubs";
<<<<<<< HEAD
  version = "1.42.19";
=======
  version = "1.41.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchPypi {
    pname = "botocore_stubs";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-L8rica8qJM1GFmJGWJsix2tJujBlazsMUEuSpJ/aHKI=";
=======
    hash = "sha256-aZyBYWUOu4C0wDxIgvQUHj5ir7wK0njrOzOJwDtwVCY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    types-awscrt
    typing-extensions
  ];

  pythonImportsCheck = [ "botocore-stubs" ];

<<<<<<< HEAD
  meta = {
    description = "Type annotations and code completion for botocore";
    homepage = "https://pypi.org/project/botocore-stubs/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Type annotations and code completion for botocore";
    homepage = "https://pypi.org/project/botocore-stubs/";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
