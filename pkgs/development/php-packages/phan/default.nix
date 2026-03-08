{
  lib,
  fetchFromGitHub,
  php,
  versionCheckHook,
}:

(php.withExtensions ({ enabled, all }: enabled ++ (with all; [ ast ]))).buildComposerProject2
  (finalAttrs: {
    pname = "phan";
    version = "6.0.2";

    src = fetchFromGitHub {
      owner = "phan";
      repo = "phan";
      tag = finalAttrs.version;
      hash = "sha256-GwiCyek+XuiXMd8LcKy79u19wySee6aRpG0e6dP44LU=";
    };

    vendorHash = "sha256-+7U2PfjagpIOaeG+8pYAgEyqh6sZT5c+knoKX/S6L0M=";

    composerStrictValidation = false;
    doInstallCheck = true;
    nativeInstallCheckInputs = [ versionCheckHook ];
    versionCheckProgramArg = "--version";

    meta = {
      description = "Static analyzer for PHP";
      homepage = "https://github.com/phan/phan";
      license = lib.licenses.mit;
      longDescription = ''
        Phan is a static analyzer for PHP. Phan prefers to avoid false-positives
        and attempts to prove incorrectness rather than correctness.
      '';
      mainProgram = "phan";
      maintainers = [ ];
      teams = [ lib.teams.php ];
    };
  })
