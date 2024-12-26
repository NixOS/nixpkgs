{
  lib,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  python,
  python-fsutil,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-maintenance-mode";
  version = "0.21.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "fabiocaccamo";
    repo = "django-maintenance-mode";
    rev = "refs/tags/${version}";
    hash = "sha256-rZo0yru+y5TkdULBQDMGAVb494PSLtbnNX/7cuphKNk=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    django
    python-fsutil
  ];

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} runtests.py

    runHook postCheck
  '';

  pythonImportsCheck = [ "maintenance_mode" ];

  meta = with lib; {
    description = "Shows a 503 error page when maintenance-mode is on";
    homepage = "https://github.com/fabiocaccamo/django-maintenance-mode";
    changelog = "https://github.com/fabiocaccamo/django-maintenance-mode/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mrmebelman ];
  };
}
