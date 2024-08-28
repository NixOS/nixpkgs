{ callPackage, stdenv, lib, ... } @ args:

callPackage ./generic.nix (args // {
  baseVersion = "3.5";
  revision = "0";
  hash = "sha256-Z+ja4cokaNkN5OYByH1fMf9JKzjoq4vL0C3fcQTtip8=";
  # this patch fixes build errors on MacOS with SDK 10.12, recheck to remove this again
  extraPatches = lib.optionals stdenv.hostPlatform.isDarwin [ ./botan3-macos.patch ];
})
