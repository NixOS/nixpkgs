{
  lib,
  fetchFromGitHub,
  php,
}:

(php.withExtensions ({ enabled, all }: enabled ++ (with all; [ ast ]))).buildComposerProject
  (finalAttrs: {
    pname = "phan";
    version = "5.5.1";

    src = fetchFromGitHub {
      owner = "phan";
      repo = "phan";
      rev = finalAttrs.version;
      hash = "sha256-G17ORkHmu6nkfJ8UrGzcaybPOKPrq1Q+LXVS56aVOZ8=";
    };

    vendorHash = "sha256-Ake5/7IyoweC2ONDuWt9jJSbG0JbnU9lmCRu2p6uUQM=";

    meta = {
      description = "Static analyzer for PHP";
      homepage = "https://github.com/phan/phan";
      license = lib.licenses.mit;
      longDescription = ''
        Phan is a static analyzer for PHP. Phan prefers to avoid false-positives
        and attempts to prove incorrectness rather than correctness.
      '';
      mainProgram = "phan";
      maintainers = with lib.maintainers; [ apeschar ];
      teams = [ lib.teams.php ];
    };
  })
