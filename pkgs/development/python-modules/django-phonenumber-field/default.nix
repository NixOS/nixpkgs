{
  lib,
  babel,
  buildPythonPackage,
  django,
  djangorestframework,
  fetchFromGitHub,
  gettext,
  phonenumbers,
  phonenumberslite,
  python,
  pytestCheckHook,
  pytest-django,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-phonenumber-field";
  version = "8.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-phonenumber-field";
    repo = "django-phonenumber-field";
    tag = finalAttrs.version;
    hash = "sha256-hTrW7QeZPBsln9iHh9sV7JMQxdJ9cFcAq4ETyhxFGv0=";
  };

  nativeBuildInputs = [ gettext ];

  build-system = [ setuptools-scm ];

  # Upstream doesn't put phonenumbers in dependencies but the package doesn't
  # make sense without either of the two optional dependencies. Since, in
  # Nixpkgs, phonenumberslite depends on phonenumbers, add the latter
  # unconditionally.
  dependencies = [ django ] ++ finalAttrs.passthru.optional-dependencies.phonenumbers;

  optional-dependencies = {
    babel = [ babel ];
    phonenumbers = [ phonenumbers ];
    phonenumberslite = [ phonenumberslite ];
  };

  preBuild = ''
    ${python.interpreter} -m django compilemessages
  '';

  nativeCheckInputs = [
    djangorestframework
    pytestCheckHook
    pytest-django
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  preCheck = ''
    export DJANGO_SETTINGS_MODULE=tests.settings
  '';

  pythonImportsCheck = [ "phonenumber_field" ];

  meta = {
    description = "Django model and form field for normalised phone numbers using python-phonenumbers";
    homepage = "https://github.com/django-phonenumber-field/django-phonenumber-field";
    changelog = "https://github.com/django-phonenumber-field/django-phonenumber-field/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sephi ];
  };
})
