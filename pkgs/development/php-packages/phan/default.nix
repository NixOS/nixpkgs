{
  lib,
  fetchFromGitHub,
  php,
  versionCheckHook,
}:

(php.withExtensions ({ enabled, all }: enabled ++ (with all; [ ast ]))).buildComposerProject2
  (finalAttrs: {
    pname = "phan";
    version = "6.0.0";

    src = fetchFromGitHub {
      owner = "phan";
      repo = "phan";
      tag = finalAttrs.version;
      hash = "sha256-1qRGNDptiAdcGc1x+iLrxe9TjLGaL8EM8xuTOUNB+Ww=";
    };

    vendorHash = "sha256-Ro5/lA72xVIkZyuRNix77Cpeyyj1GbW5J4DzjQMq0Rc=";

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
