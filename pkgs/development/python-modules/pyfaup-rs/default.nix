{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  rustPlatform,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyfaup-rs";
  version = "0.4.32";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ail-project";
    repo = "faup-rs";
    tag = "pyfaup-rs-v${finalAttrs.version}";
    hash = "sha256-SUuyekDYfNnyiXeg2OXlBjJtLdyHhAYppvWfgieo2Es=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-AI7HHBDeaoH/ArkuimcOjSc1SttYiblptPel8Yu1Yyo=";
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
