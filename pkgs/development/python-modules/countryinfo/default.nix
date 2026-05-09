{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pydantic,
  pytestCheckHook,
  typer,
}:

buildPythonPackage (finalAttrs: {
  pname = "countryinfo";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "porimol";
    repo = "countryinfo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PE9XiVH6XE+OSySL5Lo0MPWyIEX8xgeHQB7MttMfmz8=";
  };

  pythonRelaxDeps = [ "typer" ];

  build-system = [ poetry-core ];

  dependencies = [
    pydantic
    typer
  ];

  pythonImportsCheck = [ "countryinfo" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Data about countries, ISO info and states/provinces within them";
    homepage = "https://github.com/porimol/countryinfo";
    changelog = "https://github.com/porimol/countryinfo/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cizniarova ];
  };
})
