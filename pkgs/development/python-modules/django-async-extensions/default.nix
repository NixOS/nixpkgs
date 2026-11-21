{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  poetry-core,
  pytest,
  pytest-asyncio,
  pytest-django,
  pytest-mock,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-async-extensions";
  version = "0.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-utils";
    repo = "django-async-extensions";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wFr31RLLFq2iM1eChTIEPToQbCLAApNEtRGskOZaT94=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    django
  ];

  nativeCheckInputs = [
    pytest
    pytest-asyncio
    pytest-django
    pytest-mock
  ];

  checkPhase = ''
    runHook preCheck
    PYTHONPATH=.:$PYTHONPATH \
    PYTEST_ADDOPTS="-k 'not (test_prefetch_related_queryset or test_custom_error_messages or test_model_clean_error_messages)'" \
    python tests/runtests.py --settings=tests.settings
    runHook postCheck
  '';

  pythonImportsCheck = [
    "django_async_extensions"
  ];

  meta = {
    description = "Provide async capable stuff for django";
    homepage = "https://github.com/django-utils/django-async-extensions";
    license = lib.licenses.mit;
    teams = with lib.teams; [ ngi ];
  };
})
