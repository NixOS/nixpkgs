{
  lib,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage {
  pname = "ixxy-email-logger";
  version = "0-unstable-2026-10-06";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Ixxy-Open-Source";
    repo = "ixxy-email-logger";
    rev = "8bb92cf85b2b12f1eb5e32a5c7ba99c425420fa8";
    hash = "sha256-p4HBl7C4AndF+2HjdpWn4iWGi7jHX16aQk9g6Bf8tZE=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    django
  ];

  checkPhase = ''
    runHook preCheck
    python -c "
    import sys
    from django.conf import settings
    from django.core.management import execute_from_command_line

    settings.configure(
        DATABASES={'default': {'ENGINE': 'django.db.backends.sqlite3', 'NAME': ':memory:'}},
        INSTALLED_APPS=('email_logger',),
        SECRET_KEY='foobar',
    )
    execute_from_command_line(['manage.py', 'test', 'email_logger'])
    "
    runHook postCheck
  '';

  pythonImportsCheck = [
    "email_logger"
  ];

  meta = {
    description = "Email logger for Django";
    homepage = "https://github.com/Ixxy-Open-Source/ixxy-email-logger";
    license = lib.licenses.asl20;
    teams = with lib.teams; [ ngi ];
  };
}
