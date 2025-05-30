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
  pyproject = true;

  src = fetchFromGitHub {
    owner = "oxan";
    repo = "djangorestframework-dataclasses";
    tag = "v${version}";
    hash = "sha256-nUkR5xTyeBv7ziJ6Mej9TKvMOa5/k+ELBqt4BVam/wk=";
  };

  build-system = [ setuptools ];

  postPatch = ''
    patchShebangs manage.py
  '';

  dependencies = [ djangorestframework ];

  checkPhase = ''
    runHook preCheck

    ./manage.py test

    runHook postCheck
  '';

  pythonImportsCheck = [ "rest_framework_dataclasses" ];

  meta = {
    changelog = "https://github.com/oxan/djangorestframework-dataclasses/blob/${src.tag}/CHANGELOG.rst";
    description = "Dataclasses serializer for Django REST framework";
    homepage = "https://github.com/oxan/djangorestframework-dataclasses";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
