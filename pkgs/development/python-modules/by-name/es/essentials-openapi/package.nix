{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  click,
  essentials,
  flask,
  hatchling,
  httpx,
  jinja2,
  markupsafe,
  pydantic,
  pytestCheckHook,
  pyyaml,
  rich,
  setuptools,
  stdenv,
}:
buildPythonPackage rec {
  pname = "essentials-openapi";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Neoteroi";
    repo = "essentials-openapi";
    tag = "v${version}";
    hash = "sha256-HckCdDQ7wNg+uHLwAaoBIxg2cfubkcFC1mhviOeFdDg=";
  };

  nativeBuildInputs = [ hatchling ];

  nativeCheckInputs = [
    flask
    httpx
    pydantic
    pytestCheckHook
    rich
    setuptools
  ];

  propagatedBuildInputs = [
    pyyaml
    essentials
    markupsafe
  ];

  optional-dependencies = {
    full = [
      click
      jinja2
      rich
      httpx
    ];
  };

  pythonRelaxDeps = [
    "markupsafe"
  ];

  pythonImportsCheck = [ "openapidocs" ];

  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [
    # These tests start a server using a hardcoded port, and since
    # multiple Python versions are always built simultaneously, this
    # failure is quite likely to occur.
    "tests/test_cli.py"
  ];

  meta = {
    homepage = "https://github.com/Neoteroi/essentials-openapi";
    description = "Functions to handle OpenAPI Documentation";
    changelog = "https://github.com/Neoteroi/essentials-openapi/releases/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      aldoborrero
      zimbatm
    ];
  };
}
