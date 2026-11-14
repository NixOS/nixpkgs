{
  lib,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  python,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-parler";
  version = "2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-parler";
    repo = "django-parler";
    tag = "v${version}";
    hash = "sha256-vX8/0J3at97KVjWx4qxYq4wJma/QCUFHERCfXjkBieE=";
  };

  build-system = [ setuptools ];

  dependencies = [ django ];

  # Disable failing test: article.tests.AdminArticleTestCase.test_admin_add
  # AssertionError: '<h1>Ajout de Article (Hollandais)</h1>' not found in ...
  # https://github.com/django-parler/django-parler/issues/358
  preCheck = lib.optionalString (lib.versionAtLeast django.version "5.0") ''
    rm example/article/tests.py
  '';

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} runtests.py
    runHook postCheck
  '';

  meta = {
    description = "Simple Django model translations without nasty hacks";
    homepage = "https://github.com/django-parler/django-parler";
    changelog = "https://github.com/django-parler/django-parler/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ derdennisop ];
  };
}
