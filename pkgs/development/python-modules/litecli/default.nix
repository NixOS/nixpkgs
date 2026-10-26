{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  click,
  pygments,
  prompt-toolkit,
  sqlparse,
  configobj,
  cli-helpers,
}:

buildPythonPackage (finalAttrs: {
  pname = "litecli";
  version = "1.17.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dbcli";
    repo = "litecli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YSPNtDL5rNgRh5lJBKfL1jjWemlmf3eesBMSLyJVRLY=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    click
    pygments
    prompt-toolkit
    sqlparse
    configobj
    cli-helpers
  ];

  doCheck = true;

  pythonImportsCheck = [
    "litecli"
  ];

  meta = {
    description = "CLI for SQLite Databases with auto-completion and syntax highlighting";
    homepage = "https://github.com/dbcli/litecli";
    changelog = "https://github.com/dbcli/litecli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nullstring1 ];
    mainProgram = "litecli";
  };
})
