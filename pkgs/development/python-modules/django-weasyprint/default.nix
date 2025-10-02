{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  django,
  weasyprint,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "django-weasyprint";
  version = "2.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fdemmer";
    repo = "django-weasyprint";
    tag = "v${version}";
    hash = "sha256-eSh1p+5MyYb6GIEgSdlFxPzVCenlkwSCTkTzgKjezIg=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    django
    weasyprint
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "django_weasyprint" ];

  meta = {
    description = "Django class-based view generating PDF resposes using WeasyPrint";
    homepage = "https://github.com/fdemmer/django-weasyprint";
    changelog = "https://github.com/fdemmer/django-weasyprint/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hoh ];
  };
}
