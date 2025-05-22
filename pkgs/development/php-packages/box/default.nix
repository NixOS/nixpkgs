{
  lib,
  php82,
  fetchFromGitHub,
  versionCheckHook,
}:

php82.buildComposerProject2 (finalAttrs: {
  pname = "box";
  version = "4.6.6";

  src = fetchFromGitHub {
    owner = "box-project";
    repo = "box";
    tag = finalAttrs.version;
    hash = "sha256-giJAcH2R9hAlUTbwRi7rbmUP+WV8Nfb9XmoHHs4RcbI=";
  };

  vendorHash = "sha256-7oZtuQ7PhB7q9vNO2TLI46kg2q9BgdLjGUduGXAHc0E=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    changelog = "https://github.com/box-project/box/releases/tag/${finalAttrs.version}";
    description = "Application for building and managing Phars";
    homepage = "https://github.com/box-project/box";
    license = lib.licenses.mit;
    mainProgram = "box";
    teams = [ lib.teams.php ];
  };
})
