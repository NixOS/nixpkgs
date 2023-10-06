{ lib
, buildPythonPackage
, fetchFromGitHub
, djangorestframework
, setuptools
}:

buildPythonPackage rec {
  pname = "djangorestframework-dataclasses";
  version = "1.3.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "oxan";
    repo = "djangorestframework-dataclasses";
    rev = "refs/tags/v${version}";
    hash = "sha256-aUz+f8Q7RwQsoRpjq1AAmNtDzTA6KKxyc+MtBJEfyL8=";
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
    maintainers = with maintainers; [ ];
  };
}
