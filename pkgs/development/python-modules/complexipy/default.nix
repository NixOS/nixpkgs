{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  pytestCheckHook,
  tomli,
  typer,
}:

buildPythonPackage (finalAttrs: {
  pname = "complexipy";
  version = "5.6.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rohaquinlop";
    repo = "complexipy";
    tag = finalAttrs.version;
    hash = "sha256-YfLkKJghUEm0RmJihxOYg+pbhU65irb27kkUVCszhRQ=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-bSJCH41jJTxRhCsth1CzJ4dR2O7uLkoIuU+IkxknNjY=";
  };

  build-system = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  dependencies = [
    tomli
    typer
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    rm -r complexipy
  '';

  pythonImportsCheck = [ "complexipy" ];

  meta = {
    description = "Fast Python cognitive complexity analyzer written in Rust";
    mainProgram = "complexipy";
    homepage = "https://rohaquinlop.github.io/complexipy/";
    changelog = "https://github.com/rohaquinlop/complexipy/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ euank ];
  };
})
