{ lib
, buildPythonPackage
, fetchFromGitHub
, djangorestframework
, setuptools
}:

buildPythonPackage rec {
  pname = "djangorestframework-dataclasses";
<<<<<<< HEAD
  version = "1.3.0";
=======
  version = "1.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "oxan";
    repo = "djangorestframework-dataclasses";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-aUz+f8Q7RwQsoRpjq1AAmNtDzTA6KKxyc+MtBJEfyL8=";
=======
    hash = "sha256-PTX5huYdusPV6xCBW+8sFwusuPtZBH1vVApvcQU7Dlc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    setuptools
  ];

  postPatch = ''
    patchShebangs manage.py
  '';

  propagatedBuildInputs = [
    djangorestframework
  ];

  checkPhase = ''
   ./manage.py test
  '';

  pythonImportsCheck = [ "rest_framework_dataclasses" ];

  meta = with lib; {
    description = " Dataclasses serializer for Django REST framework";
    homepage = "https://github.com/oxan/djangorestframework-dataclasses";
    license = licenses.bsd3;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
