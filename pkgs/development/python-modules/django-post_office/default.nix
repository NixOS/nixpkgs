{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  django,
  nh3,
  ...
}:
buildPythonPackage rec {
  pname = "django-post_office";
  version = "3.11.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ui";
    repo = "django-post_office";
    rev = "v${version}";
    sha256 = "sha256-tK34vZWtkMeOe6+mfmgJm4aMGr1nDlKlBceBeGRRsjg=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    django
    nh3
  ];

  meta = {
    description = "A Django app that allows you to send email asynchronously in Django";
    homepage = "https://github.com/ui/django-post_office";
    changelog = "https://github.com/ui/django-post_office/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Superredstone ];
  };
}
