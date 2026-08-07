{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  rustPlatform,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyfaup-rs";
  version = "0.4.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ail-project";
    repo = "faup-rs";
    tag = "pyfaup-rs-v${finalAttrs.version}";
    hash = "sha256-rECfx7um1Rk9Fd65y3377StGru68QE13xwqDOmXQ140=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-F41gKLhly8V6dw8qE5lFLuQpSmGGfWg9EcAUMD29dsA=";
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
