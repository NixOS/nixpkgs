{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  django,
}:
buildPythonPackage (finalAttrs: {
  pname = "django-braces";
  version = "1.17.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "brack3t";
    repo = "django-braces";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IWw3jBDosxkHCRqEFppNLCnrBH5qu873y38mPBTG56A=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    django
  ];

  meta = {
    description = "Reusable, generic mixins for Django";
    license = lib.licenses.bsd3;
    homepage = "https://github.com/brack3t/django-braces";
    maintainers = with lib.maintainers; [ RossComputerGuy ];
  };
})
