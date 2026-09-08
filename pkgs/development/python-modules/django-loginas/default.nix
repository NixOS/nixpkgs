{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # tests
  django,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-loginas";
  version = "0.3.14";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "skorokithakis";
    repo = "django-loginas";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Fwb9d7Ejsg2/OzCQJxqhrbjfJIaKUg4rJIR1a3dNgUA=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [
    "loginas"
  ];

  nativeCheckInputs = [
    django
  ];

  checkPhase = ''
    runHook preCheck

    python loginas/tests/manage.py test tests --verbosity=2

    runHook postCheck
  '';

  meta = {
    description = "'Log in as user' for the Django admin";
    homepage = "https://github.com/skorokithakis/django-loginas";
    changelog = "https://github.com/skorokithakis/django-loginas/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ eljamm ];
  };
})
