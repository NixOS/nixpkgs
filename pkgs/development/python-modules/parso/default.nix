{
  lib,
  buildPythonPackage,
<<<<<<< HEAD
  fetchFromGitHub,
  setuptools,
=======
  fetchPypi,
  pythonAtLeast,
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "parso";
<<<<<<< HEAD
  version = "0.8.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "davidhalter";
    repo = "parso";
    tag = "v${version}";
    hash = "sha256-faSXCrOkybLr0bboF/8rPV/Humq8s158A3UOpdlYi0I=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Python Parser";
    homepage = "https://parso.readthedocs.io/en/latest/";
    changelog = "https://github.com/davidhalter/parso/blob/${src.tag}/CHANGELOG.rst";
    license = lib.licenses.mit;
=======
  version = "0.8.4";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6zp7WCQPuZCZo0VXHe7MD5VA6l9N0v4UwqmdaygauS0=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = lib.optionals (pythonAtLeast "3.10") [
    # python changed exception message format in 3.10, 3.10 not yet supported
    "test_python_exception_matches"
  ];

  meta = with lib; {
    description = "Python Parser";
    homepage = "https://parso.readthedocs.io/en/latest/";
    changelog = "https://github.com/davidhalter/parso/blob/master/CHANGELOG.rst";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
