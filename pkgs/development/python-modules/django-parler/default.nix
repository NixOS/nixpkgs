{
  lib,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  pythonOlder,
  python,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-parler";
  version = "2.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "django-parler";
    repo = "django-parler";
    tag = "v${version}";
    hash = "sha256-tRGifFPCXF3aa3PQWKw3tl1H1TY+lgcChUP1VdwG1cE=";
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
