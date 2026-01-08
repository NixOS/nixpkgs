{
  fetchFromGitHub,
  buildPythonPackage,
  setuptools-scm,
  lib,
  django,
  pythonOlder,
}:
buildPythonPackage rec {
  pname = "django-user-sessions";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "django-user-sessions";
    tag = version;
    hash = "sha256-Wexy6G2pZ8LTnqtJkBZIePV7qhQW8gu/mKiQfZtgf/o=";
  };

  disabled = pythonOlder "3.7";

  dependencies = [
    django
  ];

  build-system = [ setuptools-scm ];

  meta = with lib; {
    description = "Extend Django sessions with a foreign key back to the user, allowing enumerating all user's sessions.";
    homepage = "https://github.com/jazzband/django-user-sessions";
    license = licenses.mit;
    maintainers = with maintainers; [ kurogeek ];
  };
}
