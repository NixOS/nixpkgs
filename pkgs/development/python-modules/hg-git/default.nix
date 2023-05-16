{ lib
, buildPythonPackage
, fetchPypi
<<<<<<< HEAD
, setuptools-scm
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, dulwich
, mercurial
, pythonOlder
}:

buildPythonPackage rec {
  pname = "hg-git";
<<<<<<< HEAD
  version = "1.0.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WoQOh6cKFcnB4GGWvD7VlV53LxHpsYA+iMDJ9VrwNBY=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

=======
  version = "1.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-P3Ng9bD16AX7DJac/Y168GSWLTIAD3I1aLblYIDQiyk=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    dulwich
    mercurial
  ];

  pythonImportsCheck = [
    "hggit"
  ];

  meta = with lib; {
    description = "Push and pull from a Git server using Mercurial";
    homepage = "https://hg-git.github.io/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ koral ];
  };
}
