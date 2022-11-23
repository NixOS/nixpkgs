{ lib
, fetchFromGitHub
, buildPythonPackage
, pytest
, django
, python-fsutil
, pythonOlder
}:

buildPythonPackage rec {
  pname = "django-maintenance-mode";
  version = "0.17.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fabiocaccamo";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-/JMdElJsl7f6THUIvp28XcsoP/5Sa31XzGl3PZFPAH8=";
  };

  propagatedBuildInputs = [
    django
    python-fsutil
  ];

  checkInputs = [
    pytest
  ];

  pythonImportsCheck = [
    "maintenance_mode"
  ];

  meta = with lib; {
    description = "Shows a 503 error page when maintenance-mode is on";
    homepage = "https://github.com/fabiocaccamo/django-maintenance-mode";
    changelog = "https://github.com/fabiocaccamo/django-maintenance-mode/releases/tag/${version}";
    maintainers = with maintainers; [ mrmebelman ];
    license = licenses.bsd3;
  };
}
