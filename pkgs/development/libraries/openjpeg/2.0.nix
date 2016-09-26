{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2.0.1";
  branch = "2";
  revision = "version.2.0.1";
  sha256 = "1r81hq0hx2papjs3hfmpsl0024f6lblk0bq53dfm2wcpi916q7pw";
})
