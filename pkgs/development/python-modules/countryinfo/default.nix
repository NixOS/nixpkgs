{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pydantic,
  pyprojectVersionPatchHook,
  pytestCheckHook,
  typer,
}:

buildPythonPackage (finalAttrs: {
  pname = "countryinfo";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "porimol";
    repo = "countryinfo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tfikzmndpLmiph3eq6AEfQtb5w7L/wclLCnrrUFbAxU=";
  };

  pythonRelaxDeps = [ "typer" ];

  build-system = [ poetry-core ];

  dependencies = [
    pydantic
    typer
  ];

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

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
