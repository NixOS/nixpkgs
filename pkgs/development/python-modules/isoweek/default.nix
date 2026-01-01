{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
  unittestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "isoweek";
  version = "1.3.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-c/P3usRD4Fo6tFwypyBIsMTybVPYFGLsSxQsdYHT/+g=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "isoweek" ];

<<<<<<< HEAD
  meta = {
    description = "Module work with ISO weeks";
    homepage = "https://github.com/gisle/isoweek";
    changelog = "https://github.com/gisle/isoweek/releases/tag/v${version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ mrmebelman ];
=======
  meta = with lib; {
    description = "Module work with ISO weeks";
    homepage = "https://github.com/gisle/isoweek";
    changelog = "https://github.com/gisle/isoweek/releases/tag/v${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ mrmebelman ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
