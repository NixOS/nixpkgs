{
  lib,
  fetchFromGitHub,
  php,
  versionCheckHook,
}:

(php.withExtensions ({ enabled, all }: enabled ++ (with all; [ ast ]))).buildComposerProject2
  (finalAttrs: {
    pname = "phan";
    version = "6.0.1";

    src = fetchFromGitHub {
      owner = "phan";
      repo = "phan";
      tag = finalAttrs.version;
      hash = "sha256-B6n4hGsUFwFsTLUMhtmElgF0xNqfol9RQ83aP9Zs/AI=";
    };

    vendorHash = "sha256-8m0aoK6P6HUhNLh4avMm9C0qBKVfsK9zQ+iJVWVhWm4=";

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
