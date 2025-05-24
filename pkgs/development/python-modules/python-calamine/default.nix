{
  lib,
  buildPythonPackage,
  cargo,
  fetchFromGitHub,
  libiconv,
  packaging,
  poetry-core,
  pytestCheckHook,
  rustc,
  rustPlatform,
}:

buildPythonPackage rec {
  pname = "python-calamine";
  version = "0.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dimastbk";
    repo = "python-calamine";
    tag = "v${version}";
    hash = "sha256-XNTG3Vo//cFvrl3/FXaVmO0PfwCXTauvOwIP0nsjlHg=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-xqWtZV1gv2DfDF4Rf/HuyHPFPURbAaLlvY8AtdfjovY=";
  };

  buildInputs = [ libiconv ];

  build-system = [
    cargo
    poetry-core
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  dependencies = [ packaging ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "python_calamine" ];

  meta = {
    description = "Python binding for calamine";
    homepage = "https://github.com/dimastbk/python-calamine";
    changelog = "https://github.com/dimastbk/python-calamine/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "python-calamine";
  };
}
