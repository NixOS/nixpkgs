{
  lib,
  fetchFromGitHub,
  php,
  versionCheckHook,
}:

(php.withExtensions ({ enabled, all }: enabled ++ (with all; [ ast ]))).buildComposerProject2
  (finalAttrs: {
    pname = "phan";
    version = "6.0.5";

    src = fetchFromGitHub {
      owner = "phan";
      repo = "phan";
      tag = finalAttrs.version;
      hash = "sha256-R49f3SljQjNywDi7AsOHbce+4RhC59ugL5ClY8XBQho=";
    };

    vendorHash = "sha256-pzMsPFN3PXLEEWyjPTMdDCsAv6VDsIYGpma84Mu/Gos=";

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
