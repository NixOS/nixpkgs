<<<<<<< HEAD
{ lib
, buildPythonPackage
, fetchFromGitLab
, pythonOlder
, plum-py
, pytestCheckHook
, baseline
}:

buildPythonPackage rec {
  pname = "exif";
  version = "1.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
{ lib, buildPythonPackage, fetchFromGitLab, isPy3k, plum-py, pytestCheckHook, baseline }:

buildPythonPackage rec {
  pname = "exif";
  version = "1.3.5";
  disabled = !isPy3k;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    owner = "TNThieding";
    repo = "exif";
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-uiHL3m0C6+YnAHRLwzMCSzffrQsSyVcuem6FBtTLxek=";
  };

  propagatedBuildInputs = [
    plum-py
  ];

  nativeCheckInputs = [
    pytestCheckHook
    baseline
  ];

  pythonImportsCheck = [
    "exif"
  ];

  meta = with lib; {
    description = "Read and modify image EXIF metadata using Python";
    homepage = "https://gitlab.com/TNThieding/exif";
    changelog = "https://gitlab.com/TNThieding/exif/-/blob/v${version}/docs/release_notes.rst";
    license = licenses.mit;
=======
    rev = "v${version}";
    hash = "sha256-XSORawioXo8oPVZ3Jnxqa6GFIxnQZMT0vJitdmpBj0E=";
  };

  propagatedBuildInputs = [ plum-py ];

  nativeCheckInputs = [ pytestCheckHook baseline ];

  pythonImportsCheck = [ "exif" ];

  meta = with lib; {
    description = "Read and modify image EXIF metadata using Python";
    homepage    = "https://gitlab.com/TNThieding/exif";
    license     = licenses.mit;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ dnr ];
  };
}
