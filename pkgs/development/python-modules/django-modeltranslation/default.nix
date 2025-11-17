{
  lib,
  buildPythonPackage,
  django-stubs,
  django,
  fetchFromGitHub,
  parameterized,
  pytest-cov-stub,
  pytest-django,
  pytestCheckHook,
  pythonOlder,
  hatchling,
  hatch-vcs,
}:

buildPythonPackage rec {
  pname = "django-modeltranslation";
  version = "0.19.17";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "deschler";
    repo = "django-modeltranslation";
    tag = "v${version}";
    hash = "sha256-SaCuo/vnH7fDZnOZvrV3HbLtq6q2bTzhPvBCdrzukoA=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [ django ];

  nativeCheckInputs = [
    django-stubs
    pytestCheckHook
    pytest-cov-stub
    pytest-django
    parameterized
  ];

  pythonImportsCheck = [ "modeltranslation" ];

  meta = {
    description = "Translates Django models using a registration approach";
    homepage = "https://github.com/deschler/django-modeltranslation";
    changelog = "https://github.com/deschler/django-modeltranslation/blob/v${src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ augustebaum ];
  };
}
