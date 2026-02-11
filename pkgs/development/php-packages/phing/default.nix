{
  lib,
  fetchgit,
  php,
  versionCheckHook,
}:

(php.withExtensions ({ enabled, all }: enabled ++ (with all; [ xsl ]))).buildComposerProject2
  (finalAttrs: {
    pname = "phing";
    version = "3.1.1";

    # Upstream no longer provides the composer.lock in their release artifact
    src = fetchgit {
      url = "https://github.com/phingofficial/phing";
      tag = finalAttrs.version;
      hash = "sha256-2v16ojUDIECLfwWy8/Rbp1A6LlAXnjr4/dJLh6oog8w=";
    };

    vendorHash = "sha256-dBk4/Mz2jh7Bq9VfdfvnWqSufbeAeVdC85zAnXVFQNA=";

    nativeInstallCheckInputs = [
      versionCheckHook
    ];
    versionCheckProgramArg = "-version";
    doInstallCheck = true;

    meta = {
      description = "PHing Is Not GNU make; it's a PHP project build system or build tool based on Apache Ant";
      changelog = "https://github.com/phingofficial/phing/releases/tag/${finalAttrs.version}";
      homepage = "https://github.com/phingofficial/phing";
      license = lib.licenses.lgpl3;
      mainProgram = "phing";
      teams = [ lib.teams.php ];
    };
  })
