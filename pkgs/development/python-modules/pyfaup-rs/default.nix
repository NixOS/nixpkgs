{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  rustPlatform,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyfaup-rs";
  version = "0.4.30";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ail-project";
    repo = "faup-rs";
    tag = "pyfaup-rs-v${finalAttrs.version}";
    hash = "sha256-Qh6wGUyebgjeRt8ioFlYPBZpG7zsBF3v1r8zc4DDknQ=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-Ners/8HcZSASCM4CydEjYV7wyk6TI8c8pghOm/KDpvc=";
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
