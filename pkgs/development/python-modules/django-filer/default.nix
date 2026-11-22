{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  pytestCheckHook,
  django-polymorphic,
  setuptools,
  python,
  easy-thumbnails,
  pillow-heif,
  py-svg-hush,
  django-app-helper,
  distutils,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "django-filer";
  version = "3.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-cms";
    repo = "django-filer";
    tag = version;
    hash = "sha256-Mi4LqW6kSL1H4FBgkCbTxyNM61LnY/gw4kiqGus8BLs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    django
    django-polymorphic
    easy-thumbnails
    py-svg-hush
  ];

  optional-dependencies = {
    heif = [ pillow-heif ];
    svg = easy-thumbnails.optional-dependencies.svg;
  };

  checkInputs = [
    distutils
    django-app-helper
  ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} tests/settings.py
    runHook postCheck
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=^([0-9]+\\.[0-9]+\\.[0-9]+)$" ];
  };

  meta = {
    changelog = "https://github.com/django-cms/django-filer/blob/${src.tag}/CHANGELOG.rst";
    description = "File management application for Django";
    homepage = "https://github.com/django-cms/django-filer";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.onny ];
  };
}
