{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  packaging,
  pytestCheckHook,
  python,
  python-dateutil,
  pytz,
  trove-classifiers,
  tzlocal,
  versionCheckHook,
  which,
}:

buildPythonPackage (finalAttrs: {
  pname = "croniter";
  version = "6.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pallets-eco";
    repo = "croniter";
    tag = "${finalAttrs.version}";
    hash = "sha256-Ff6fHFBOBQmrf8OLPNuhHjRqyPuS1sStd5hWh4oI0cI=";
  };

  build-system = [
    hatchling
    packaging
    trove-classifiers
  ];

  dependencies = [ python-dateutil ];

  nativeCheckInputs = [
    pytestCheckHook
    pytz
    tzlocal
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "hatchling==1.30.1" "hatchling>=1.30.1"
  '';

  pythonImportsCheck = [ "croniter" ];

  nativeInstallCheckInputs = [
    versionCheckHook
    which
  ];

  versionCheckProgramArg = "${placeholder "out"}/${python.sitePackages}";

  preInstallCheck = ''
    versionCheckProgram="$(which ls)"
  '';

  meta = {
    description = "Library to iterate over datetime object with cron like format";
    homepage = "https://github.com/kiorky/croniter";
    changelog = "https://github.com/kiorky/croniter/blob/${finalAttrs.version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
