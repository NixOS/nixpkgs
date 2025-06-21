{
  lib,
  fetchFromGitHub,
  php,
}:

(php.withExtensions ({ enabled, all }: enabled ++ (with all; [ ast ]))).buildComposerProject
  (finalAttrs: {
    pname = "phan";
    version = "5.4.6";

    src = fetchFromGitHub {
      owner = "phan";
      repo = "phan";
      rev = finalAttrs.version;
      hash = "sha256-627Vc8jFrC2wifvGoZ18w72mp43myk4/adyJR28sFEw=";
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
