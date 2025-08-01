{
  lib,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  python,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "django-pwa";
  version = "2.0.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "silviolleite";
    repo = "django-pwa";
    tag = version;
    hash = "sha256-EAjDK3rkjoPw8jyVVZdhMNHmTqr0/ERiMwGMxmVbsls=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [ django ];

  pythonImportsCheck = [ "pwa" ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} runtests.py
    runHook postCheck
  '';

  meta = with lib; {
    description = "Django app to include a manifest.json and Service Worker instance to enable progressive web app behavior";
    homepage = "https://github.com/silviolleite/django-pwa";
    changelog = "https://github.com/silviolleite/django-pwa/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ derdennisop ];
  };
}
