{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  django,
  django-stubs-ext,
  typing-extensions,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "django-fsm-2";
  version = "4.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-commons";
    repo = "django-fsm-2";
    tag = version;
    hash = "sha256-iSFNhAJNrag7EeLO55TFonGU9E0P1mqJtR8PGwK1QCk=";
  };

  build-system = [ hatchling ];

  dependencies = [
    django
    django-stubs-ext
  ]
  ++ lib.optionals (pythonOlder "3.12") [ typing-extensions ];

  # The upstream test suite depends on django-fsm-log and django-unfold,
  # which are not packaged in nixpkgs yet.
  doCheck = false;

  pythonImportsCheck = [ "django_fsm" ];

  meta = {
    description = "Django friendly finite state machine support";
    homepage = "https://github.com/django-commons/django-fsm-2";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.kurogeek ];
  };
}
