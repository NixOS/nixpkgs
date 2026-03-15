{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
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

  build-system = [
    setuptools
    wheel
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
