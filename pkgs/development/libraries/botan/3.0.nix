{ callPackage, stdenv, lib, ... } @ args:

callPackage ./generic.nix (args // {
  baseVersion = "3.4";
  revision = "0";
  hash = "sha256-cYQ6/MCixYX48z+jBPC1iuS5xdgwb4lGZ7N0YEQndVc=";
  # this patch fixes build errors on MacOS with SDK 10.12, recheck to remove this again
  extraPatches = lib.optionals stdenv.hostPlatform.isDarwin [ ./botan3-macos.patch ];
})
