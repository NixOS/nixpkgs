{
  fetchFromGitHub,
  lib,
  php,
  versionCheckHook,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "grumphp";
  version = "2.17.0";

  src = fetchFromGitHub {
    owner = "phpro";
    repo = "grumphp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-g2V2clNI0+KzKAPStq1vJZ3gHpBV1EbduWBmzRnuzv8=";
  };

  vendorHash = "sha256-lgXDxfBTCtGlrDzi+leeE8J8VIsaKpwyB1CUTUvdpMg=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    changelog = "https://github.com/phpro/grumphp/releases/tag/v${finalAttrs.version}";
    description = "PHP code-quality tool";
    homepage = "https://github.com/phpro/grumphp";
    license = lib.licenses.mit;
    mainProgram = "grumphp";
    teams = [ lib.teams.php ];
  };
})
