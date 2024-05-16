{
  lib,
  fetchFromGitHub,
  php,
}:

(php.withExtensions ({ enabled, all }: enabled ++ (with all; [ ast ]))).buildComposerProject
  (finalAttrs: {
    pname = "phan";
    version = "5.4.3";

    src = fetchFromGitHub {
      owner = "phan";
      repo = "phan";
      rev = finalAttrs.version;
      hash = "sha256-O0dtnDsz6X99B99VbRQf3Wr/xJfsJqd+2l5Z5iWxHyU=";
    };

    vendorHash = "sha256-yE85MBseJa0VGV5EbjT0te4QT3697YvtumGkMMfZtxI=";

    meta = {
      description = "Static analyzer for PHP";
      homepage = "https://github.com/phan/phan";
      license = lib.licenses.mit;
      longDescription = ''
        Phan is a static analyzer for PHP. Phan prefers to avoid false-positives
        and attempts to prove incorrectness rather than correctness.
      '';
      mainProgram = "phan";
      maintainers = with lib.maintainers; [ apeschar ] ++ lib.teams.php.members;
    };
  })
