{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-scm,
  django,
  django-appconf,
}:
buildPythonPackage (finalAttrs: {
  pname = "django-decorator-include";
  version = "3.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "twidi";
    repo = "django-decorator-include";
    tag = finalAttrs.version;
    hash = "sha256-6YaDDCM2nrOuiMwvR2pQopOejlU2S4Qq8ct7yPP159E=";
  };

  build-system = [ flit-scm ];

  dependencies = [
    django
    django-appconf
  ];

  checkPhase = ''
    runHook preCheck
    ./runtests.sh
    runHook postCheck
  '';

  pythonImportsCheck = [
    "decorator_include"
  ];

  meta = {
    description = "Include Django URL patterns with decorators";
    homepage = "https://github.com/twidi/django-decorator-include";
    changelog = "https://github.com/twidi/django-decorator-include/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ dav-wolff ];
  };
})
