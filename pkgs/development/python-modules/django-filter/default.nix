{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  django,
  djangorestframework,
  pytestCheckHook,
  pytest-django,
  pytz,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-filter";
  version = "26.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "carltongibson";
    repo = "django-filter";
    tag = finalAttrs.version;
    hash = "sha256-Sls/imzl2dzUfVcJTUqpCQTDRH9H09uxx27TnU0R0WI=";
  };

  build-system = [ flit-core ];

  dependencies = [ django ];

  optional-dependencies.drf = [ djangorestframework ];

  pythonImportsCheck = [ "django_filters" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
    pytz
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  env.DJANGO_SETTINGS_MODULE = "tests.settings";

  meta = {
    description = "Reusable Django application for allowing users to filter querysets dynamically";
    homepage = "https://github.com/carltongibson/django-filter";
    changelog = "https://github.com/carltongibson/django-filter/blob/${finalAttrs.src.tag}/CHANGES.rst";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
