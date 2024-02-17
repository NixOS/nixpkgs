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
  pythonImportsCheckHook,
  pyyaml,
  rich,
  setuptools
}:
buildPythonPackage rec {
  pname = "essentials-openapi";
  version = "1.0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Neoteroi";
    repo = "essentials-openapi";
    rev = "v${version}";
    hash = "sha256-j0vEMNXZ9TrcFx8iIyTFQIwF49LEincLmnAt+qodYmA=";
  };

  nativeBuildInputs = [
    hatchling
  ];

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

  passthru.optional-dependencies = {
    full = [ click jinja2 rich httpx ];
  };

  pythonImportsCheck = [
    "openapidocs"
  ];

  meta = with lib; {
    homepage = "https://github.com/Neoteroi/essentials-openapi";
    description = "Functions to handle OpenAPI Documentation";
    changelog = "https://github.com/Neoteroi/essentials-openapi/releases/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [aldoborrero zimbatm];
  };
}
