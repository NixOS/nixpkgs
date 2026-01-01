{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
<<<<<<< HEAD
  setuptools,
  pytestCheckHook,
=======
  pytestCheckHook,
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "eradicate";
<<<<<<< HEAD
  version = "3.0.1";
  pyproject = true;
=======
  version = "3.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "wemake-services";
    repo = "eradicate";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-D9V9PQ3HVmShmPgTInOJaVmujy1fQyQn6qYn/Pa0kMg=";
  };

  build-system = [ setuptools ];

=======
    hash = "sha256-V3g9qYM/TiOz83IMoUwu0CvFWBxB5Yk3Dy3G/Dz3vYw=";
  };

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "eradicate" ];

  enabledTestPaths = [ "test_eradicate.py" ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Library to remove commented-out code from Python files";
    mainProgram = "eradicate";
    homepage = "https://github.com/myint/eradicate";
    changelog = "https://github.com/wemake-services/eradicate/releases/tag/${src.tag}";
<<<<<<< HEAD
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ mmlb ];
=======
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ mmlb ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
