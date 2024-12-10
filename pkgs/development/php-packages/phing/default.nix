{
  lib,
  fetchgit,
  php,
}:

(php.withExtensions ({ enabled, all }: enabled ++ (with all; [ xsl ]))).buildComposerProject2
  (finalAttrs: {
    pname = "phing";
    version = "3.0.1";

    # Upstream no longer provides the composer.lock in their release artifact
    src = fetchgit {
      url = "https://github.com/phingofficial/phing";
      rev = "refs/tags/${finalAttrs.version}";
      hash = "sha256-eVDHwG8UPvQPrhD3KuO4ZONsnGGbclVs4kNVG+Ac1/E=";
    };

    vendorHash = "sha256-NqCzrVZRsyiOjxXtSE7DeiAq21S8sjFgFNMmP99KUSE=";

    meta = {
      description = "PHing Is Not GNU make; it's a PHP project build system or build tool based on Apache Ant";
      changelog = "https://github.com/phingofficial/phing/releases/tag/${finalAttrs.version}";
      homepage = "https://github.com/phingofficial/phing";
      license = lib.licenses.lgpl3;
      mainProgram = "phing";
      maintainers = lib.teams.php.members;
    };
  })
