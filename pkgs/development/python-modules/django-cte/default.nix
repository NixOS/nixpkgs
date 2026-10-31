{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  flit-core,
  django,
  pytest-unmagic,
}:

buildPythonPackage rec {
  pname = "django-cte";
  version = "4.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dimagi";
    repo = "django-cte";
    tag = "v${version}";
    hash = "sha256-HkOFpZWHtRrakenNPL68y4yBRl5f/Eqvcfs5xE+x/Rs=";
  };

  build-system = [
    flit-core
  ];

  dependencies = [ django ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-unmagic
  ];

  pythonImportsCheck = [ "django_cte" ];

  meta = {
    description = "Common Table Expressions (CTE) for Django";
    homepage = "https://github.com/dimagi/django-cte";
    changelog = "https://github.com/dimagi/django-cte/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
