{
  lib,
  fetchFromGitHub,
  php,
}:

(php.withExtensions ({ enabled, all }: enabled ++ (with all; [ ast ]))).buildComposerProject
  (finalAttrs: {
    pname = "phan";
    version = "5.4.5";

    src = fetchFromGitHub {
      owner = "phan";
      repo = "phan";
      rev = finalAttrs.version;
      hash = "sha256-CSV+kapCzGOCBaYnX0lJVlDdZGNBCKZ/nogOac1xj1A=";
    };

    vendorHash = "sha256-qRcB0KmUJWRQaMlnK1JdUsZrikThD6nQnrqQZm9yROk=";

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
