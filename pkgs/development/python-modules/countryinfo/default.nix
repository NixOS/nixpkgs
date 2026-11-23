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
    hash = "sha256-nd5KQdpQzRaPHwA2u8DCIWZEskODTkmG1r+piHvEEVo=";
    # fix for case-insensitive filesystems
    postFetch = ''
      cd "$out/countryinfo/data"
      cp curaçao.json "$TMPDIR/curacao.json"
      rm -f Curaçao.json curaçao.json
      cp "$TMPDIR/curacao.json" curaçao.json
    '';
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
