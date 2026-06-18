{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  rustPlatform,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyfaup-rs";
  version = "0.4.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ail-project";
    repo = "faup-rs";
    tag = "pyfaup-rs-v${finalAttrs.version}";
    hash = "sha256-bfUMOuG8wqCoB+32NKApuPPPIZIBvmlMLGD30Wf5hWM=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-s8JwFAERQXWpu84aseI+L+pB3JEafX81HMydjOcwcgE=";
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
