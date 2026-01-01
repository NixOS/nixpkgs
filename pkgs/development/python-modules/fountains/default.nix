{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  bitlist,
}:

buildPythonPackage rec {
  pname = "fountains";
  version = "3.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gGYmHvlD9cmivPtM/2sKW36FvUzk5FxYBgZfLUX2lIg=";
  };

  build-system = [ setuptools ];

  dependencies = [ bitlist ];

  # Module has no test
  doCheck = false;

  pythonImportsCheck = [ "fountains" ];

<<<<<<< HEAD
  meta = {
    description = "Python library for generating and embedding data for unit testing";
    homepage = "https://github.com/reity/fountains";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Python library for generating and embedding data for unit testing";
    homepage = "https://github.com/reity/fountains";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
