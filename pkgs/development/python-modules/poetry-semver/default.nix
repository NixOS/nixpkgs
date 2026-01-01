{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "poetry-semver";
  version = "0.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2Am2Eqons5vy0PydMbT0gJsOlyZGxfGc+kbHJbdjiBA=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

<<<<<<< HEAD
  meta = {
    description = "Semantic versioning library for Python";
    homepage = "https://github.com/python-poetry/semver";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cpcloud ];
=======
  meta = with lib; {
    description = "Semantic versioning library for Python";
    homepage = "https://github.com/python-poetry/semver";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
