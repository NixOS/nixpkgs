{
  lib,
  buildPythonPackage,
  django,
  django-tables2,
  django-tastypie,
  factory-boy,
  fetchFromGitHub,
  poetry-core,
  pylint-plugin-utils,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pylint-django";
  version = "2.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = "pylint-django";
    tag = "v${finalAttrs.version}";
    hash = "sha256-f0L/wYedLHtyi3/vro4n29oAY+axnQ5sBv545zD/Gvc=";
  };

  build-system = [ poetry-core ];

  dependencies = [ pylint-plugin-utils ];

  optional-dependencies = {
    with_django = [ django ];
  };

  nativeCheckInputs = [
    django-tables2
    django-tastypie
    factory-boy
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pylint_django" ];

  meta = {
    description = "Pylint plugin to analyze Django applications";
    homepage = "https://github.com/PyCQA/pylint-django";
    changelog = "https://github.com/pylint-dev/pylint-django/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ kamadorueda ];
  };
})
