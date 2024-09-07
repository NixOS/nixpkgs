{
  lib,
  babel,
  buildPythonPackage,
  django,
  djangorestframework,
  fetchFromGitHub,
  phonenumbers,
  phonenumberslite,
  python,
  pythonOlder,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "django-phonenumber-field";
  version = "8.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "stefanfoulis";
    repo = "django-phonenumber-field";
    rev = "refs/tags/${version}";
    hash = "sha256-l+BAh7QYGN0AgDHICvlQnBYAcpEn8acu+JBmoo85kF0=";
  };

  build-system = [ setuptools-scm ];

  # Upstream doesn't put phonenumbers in dependencies but the package doesn't
  # make sense without either of the two optional dependencies. Since, in
  # Nixpkgs, phonenumberslite depends on phonenumbers, add the latter
  # unconditionally.
  dependencies = [ django ] ++ optional-dependencies.phonenumbers;

  nativeCheckInputs = [
    babel
    djangorestframework
  ];

  pythonImportsCheck = [ "phonenumber_field" ];

  checkPhase = ''
    ${python.interpreter} -m django test --settings tests.settings
  '';

  optional-dependencies = {
    phonenumbers = [ phonenumbers ];
    phonenumberslite = [ phonenumberslite ];
  };

  meta = with lib; {
    description = "Django model and form field for normalised phone numbers using python-phonenumbers";
    homepage = "https://github.com/stefanfoulis/django-phonenumber-field/";
    changelog = "https://github.com/stefanfoulis/django-phonenumber-field/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ sephi ];
  };
}
