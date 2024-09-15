{
  lib,
  fetchFromGitHub,
  php,
}:

(php.withExtensions ({ enabled, all }: enabled ++ (with all; [ xsl ]))).buildComposerProject
  (finalAttrs: {
    pname = "phing";
    version = "3.0.0-rc6";

    src = fetchFromGitHub {
      owner = "phingofficial";
      repo = "phing";
      rev = finalAttrs.version;
      hash = "sha256-pOt6uQaz69WuHKYZhq6FFbjyHGrEc+Bf0Sw9uCS3Nrc=";
    };

    # TODO: Open a PR against https://github.com/phingofficial/phing
    # Their `composer.lock` is out of date therefore, we need to provide one
    composerLock = ./composer.lock;
    vendorHash = "sha256-ueTbbz3FGyRcRvlcJNirHdC77Tko4RKtYMFB3+4JdnQ=";

    meta = {
      description = "PHing Is Not GNU make; it's a PHP project build system or build tool based on Apache Ant";
      homepage = "https://github.com/phingofficial/phing";
      license = lib.licenses.lgpl3;
      mainProgram = "phing";
      maintainers = lib.teams.php.members;
    };
  })
