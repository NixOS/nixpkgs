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
  version = "6.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pallets-eco";
    repo = "croniter";
    tag = "${finalAttrs.version}";
    hash = "sha256-RuUQ1wL/fwB8kD5yEaGHa9jkDKGQgzLLYTwJdcY7Q2s=";
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
      --replace-fail "packaging==26.0" "packaging>=26.0" \
      --replace-fail "trove-classifiers==2026.1.14.14" "trove-classifiers>=2026.1.14.14"
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
