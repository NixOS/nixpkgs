{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyprobables";
<<<<<<< HEAD
  version = "0.6.2";
  pyproject = true;

=======
  version = "0.6.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "barrust";
    repo = "pyprobables";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-CxxpiYtqoAm81YjL6nTFIk4MnBG+1n3wbnW8u29lQlw=";
=======
    hash = "sha256-yJUYGfy+d+Xfk1DUDvBeWk0EcNPuW4DcUHx3G3jzEdc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "probables" ];

<<<<<<< HEAD
  meta = {
    description = "Probabilistic data structures";
    homepage = "https://github.com/barrust/pyprobables";
    changelog = "https://github.com/barrust/pyprobables/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Probabilistic data structures";
    homepage = "https://github.com/barrust/pyprobables";
    changelog = "https://github.com/barrust/pyprobables/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
