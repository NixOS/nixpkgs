{
  fetchFromGitHub,
  buildPythonPackage,
  setuptools-scm,
  lib,
  django,
}:
buildPythonPackage rec {
  pname = "django-user-sessions";
  version = "3.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "django-user-sessions";
    tag = version;
    hash = "sha256-vHLeEmlVil1iJi+YkxL5c04Vq/b5b43tjC2ZcjH4/Ys=";
  };

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
