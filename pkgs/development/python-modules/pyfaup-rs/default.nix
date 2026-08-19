{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  rustPlatform,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyfaup-rs";
  version = "0.4.17";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ail-project";
    repo = "faup-rs";
    tag = "pyfaup-rs-v${finalAttrs.version}";
    hash = "sha256-vuJuC5PutjObGXzVlJP+U+vpTKDJbrn85TJJOe5cmEQ=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-LBFB8hbvOMnwM9aFoSF2T8iOG4xGpKFWYJO8nOpLbn0=";
  };

  buildAndTestSubdir = "python";

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyfaup" ];

  meta = {
    description = "Url parsing library";
    homepage = "https://github.com/ail-project/faup-rs";
    changelog = "https://github.com/ail-project/faup-rs/releases/tag/pyfaup-rs-${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
