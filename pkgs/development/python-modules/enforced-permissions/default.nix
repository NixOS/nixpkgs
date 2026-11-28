{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  django,
}:

buildPythonPackage {
  pname = "enforced-permissions";
  version = "0-unstable-2025-08-28";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Ixxy-Open-Source";
    repo = "django-enforced-permissions";
    rev = "f1f821e39c67f198fb84632ad3ab91bac9c537e8";
    hash = "sha256-wkqsA/gonTQRrGPcpGk4Lekcfe8vn8cr54wAxCvcwiA=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    django
  ];

  pythonImportsCheck = [
    "enforced_permissions"
  ];

  doCheck = false; # no tests upstream

  meta = {
    description = "Enforce permissions in django settings";
    homepage = "https://github.com/Ixxy-Open-Source/django-enforced-permissions";
    license = lib.licenses.bsd3;
    teams = with lib.teams; [ ngi ];
  };
}
