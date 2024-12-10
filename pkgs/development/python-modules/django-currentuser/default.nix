{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  pythonOlder,
  django,
  hatchling,
  pyhamcrest,
}:
let
  version = "0.6.1";
in
buildPythonPackage {
  pname = "django-currentuser";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zsoldosp";
    repo = "django-currentuser";
    rev = "v${version}";
    hash = "sha256-sxt4ZMkaFANINd1faIA5pqP8UoDMXElM3unsxcJU/ag=";
  };

  disabled = pythonOlder "3.8";

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [ django ];

  nativeCheckInputs = [ pyhamcrest ];

  preCheck = ''
    DJANGO_SETTINGS_MODULE="settings"
    PYTHONPATH="tests:$PYTHONPATH"
  '';

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} manage.py test testapp
    runHook postCheck
  '';

  meta = with lib; {
    description = "Conveniently store reference to request user on thread/db level";
    homepage = "https://github.com/zsoldosp/django-currentuser";
    changelog = "https://github.com/zsoldosp/django-currentuser/#release-notes";
    license = licenses.bsd3;
    maintainers = with maintainers; [ augustebaum ];
  };
}
