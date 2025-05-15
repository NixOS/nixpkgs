{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  djangorestframework,
  setuptools,
}:

buildPythonPackage rec {
  pname = "djangorestframework-dataclasses";
  version = "1.4.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "oxan";
    repo = "djangorestframework-dataclasses";
    tag = "v${version}";
    hash = "sha256-nUkR5xTyeBv7ziJ6Mej9TKvMOa5/k+ELBqt4BVam/wk=";
  };

  nativeBuildInputs = [ setuptools ];

  postPatch = ''
    patchShebangs manage.py
  '';

  propagatedBuildInputs = [ djangorestframework ];

  checkPhase = ''
    ./manage.py test
  '';

  pythonImportsCheck = [ "rest_framework_dataclasses" ];

  meta = with lib; {
    description = " Dataclasses serializer for Django REST framework";
    homepage = "https://github.com/oxan/djangorestframework-dataclasses";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
