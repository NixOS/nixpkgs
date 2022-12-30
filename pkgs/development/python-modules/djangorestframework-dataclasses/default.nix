{ lib
, buildPythonPackage
, fetchFromGitHub
, djangorestframework
}:

buildPythonPackage rec {
  pname = "djangorestframework-dataclasses";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "oxan";
    repo = "djangorestframework-dataclasses";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-PTX5huYdusPV6xCBW+8sFwusuPtZBH1vVApvcQU7Dlc=";
  };

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
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
