{
  lib,
  rustPlatform,
  fetchFromGitHub,
  writers,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "xee";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "Paligo";
    repo = "xee";
    tag = "xee-v${finalAttrs.version}";
    hash = "sha256-AU1x2Y2oDaUi4XliOf3GxJCwPv/OMTTUE2p/SOJtM2k=";
  };

  cargoHash = "sha256-30OXowgIVSXMFEZVM74kwU8mdDuXVngsISyVQ0MB+VQ=";

  cargoBuildFlags = [
    "--package"
    "xee"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    description = "XML Execution Engine written in Rust";
    longDescription = ''
      Load XML documents, issue XPath expressions against them, including in
      a REPL, and pretty-print XML documents. A Swiss Army knife CLI for XML.
    '';
    homepage = "https://github.com/Paligo/xee";
    changelog = "https://github.com/Paligo/xee/releases/tag/xee-v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pbsds ];
    mainProgram = "xee";
  };
})
