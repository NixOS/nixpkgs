{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  sqlite,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "urx";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "hahwul";
    repo = "urx";
    tag = finalAttrs.version;
    hash = "sha256-NSPEAA+tD1CdCjRj3myQB8bPdMhT7H76qAIIWx2z++I=";
  };

  cargoHash = "sha256-nPm4ofmu03Rb12spjb+m36C6EauJIppgqTkX1oJF3uk=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ sqlite ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  __structuredAttrs = true;

  checkFlags = [
    # Tests require network access
    "--skip=providers"
    "--skip=network::client::tests"
  ];

  doInstallCheck = true;

  versionCheckProgramArg = [ "--version" ];

  meta = {
    description = "Extracts URLs from OSINT Archives for Security Insights";
    homepage = "https://github.com/hahwul/urx";
    changelog = "https://github.com/hahwul/urx/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "urx";
  };
})
