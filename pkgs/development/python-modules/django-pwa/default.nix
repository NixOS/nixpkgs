{
  lib,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  python,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-pwa";
  version = "1.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "silviolleite";
    repo = "django-pwa";
    rev = "refs/tags/v${version}";
    hash = "sha256-tP1+Jm9hdvN/ZliuVHN8tqy24/tOK1LUUiJv1xUqRrY=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ django ];

  pyImportCheck = [ "pwa" ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} runtests.py
    runHook postCheck
  '';

  meta = with lib; {
    description = "Django app to include a manifest.json and Service Worker instance to enable progressive web app behavoir";
    homepage = "https://github.com/silviolleite/django-pwa";
    changelog = "https://github.com/silviolleite/django-pwa/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ derdennisop ];
  };
}
