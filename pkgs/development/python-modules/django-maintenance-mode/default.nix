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
  version = "0.22.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "fabiocaccamo";
    repo = "django-maintenance-mode";
    tag = version;
    hash = "sha256-Gd6Bmir0bHsD7Xaq1N9S8bSMGQWbVCBIA8Cftzu6QB0=";
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
    changelog = "https://github.com/fabiocaccamo/django-maintenance-mode/releases/tag/${src.tag}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mrmebelman ];
  };
}
