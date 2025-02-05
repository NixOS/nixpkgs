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
}:
buildPythonPackage rec {
  pname = "essentials-openapi";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Neoteroi";
    repo = "essentials-openapi";
    tag = "v${version}";
    hash = "sha256-XPsVPeKaaDwBFrUoydSa/7UPhw46JWMu3ww3MZfy7wg=";
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
