{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  django,
  django-modeltranslation,
}:

buildPythonPackage rec {
  pname = "django-autoslug";
  version = "1.9.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "justinmayer";
    repo = "django-autoslug";
    tag = "v${version}";
    hash = "sha256-IRLY4VaKYXVkSgU/zdY+PSmGrcFB2FlE5L7j0FqisRM=";
  };

  postPatch = lib.optionalString (lib.versionAtLeast django.version "6.0") ''
    # sadly upstream does not use pytest, so we must patch the one failing test or we could not run any tests at all
    # see https://github.com/justinmayer/django-autoslug/issues/87
    substituteInPlace autoslug/tests/tests.py \
      --replace-fail "assert b.slug == 'hello_world-2'" "assert b.slug == 'hello_world_2'"
  '';

  build-system = [
    setuptools
  ];

  dependencies = [ django ];

  nativeCheckInputs = [ django-modeltranslation ];

  checkPhase = ''
    runHook preCheck

    python run_tests.py

    runHook postCheck
  '';

  meta = {
    description = "AutoSlugField for Django";
    homepage = "https://github.com/justinmayer/django-autoslug";
    changelog = "https://github.com/justinmayer/django-autoslug/blob/v${version}/CHANGELOG.rst";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ defelo ];
  };
}
