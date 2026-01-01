{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pygobject-stubs";
<<<<<<< HEAD
  version = "2.14.0";
=======
  version = "2.13.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pygobject";
    repo = "pygobject-stubs";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-pConIc8FBq2a7yrfRHa07p2e/Axgrv4p+W0nq1WzERw=";
=======
    hash = "sha256-d7caFIjRRFEZYyCDUcilJ7iquUdltZ0ZQupxQ6ITUEc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  # This package does not include any tests.
  doCheck = false;

<<<<<<< HEAD
  meta = {
    description = "PEP 561 Typing Stubs for PyGObject";
    homepage = "https://github.com/pygobject/pygobject-stubs";
    changelog = "https://github.com/pygobject/pygobject-stubs/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ hacker1024 ];
=======
  meta = with lib; {
    description = "PEP 561 Typing Stubs for PyGObject";
    homepage = "https://github.com/pygobject/pygobject-stubs";
    changelog = "https://github.com/pygobject/pygobject-stubs/blob/${src.tag}/CHANGELOG.md";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ hacker1024 ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
