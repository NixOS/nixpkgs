{ lib
, buildPythonPackage
, fetchFromGitHub
, djangorestframework
}:

buildPythonPackage rec {
  pname = "djangorestframework-dataclasses";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "oxan";
    repo = "djangorestframework-dataclasses";
    rev = "v${version}";
    sha256 = "sha256-wXgA/4Dik6yG0nKl9GbrHgb2lhrPsgS23+cEyaD9MRY=";
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
