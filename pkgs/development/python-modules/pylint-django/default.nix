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
  version = "2.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = "pylint-django";
    tag = "v${finalAttrs.version}";
    hash = "sha256-W3BPCK6fj4poZ1EaBUGyVyfRo/0sZa+2ktk96Ic6+q0=";
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
