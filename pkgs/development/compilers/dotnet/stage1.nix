{
  stdenv,
  lib,
  callPackage,

  releaseManifestFile,
  tarballHash,
  depsFile,
  bootstrapSdk,
}@args:

let
  mkPackages = callPackage ./packages.nix;
  mkVMR = callPackage ./vmr.nix;

  stage0 = callPackage ./stage0.nix args;

  vmr =
    (mkVMR {
      inherit releaseManifestFile tarballHash;
      bootstrapSdk = stage0.sdk;
    }).overrideAttrs
      (old: {
        passthru = old.passthru or { } // {
          inherit (stage0.vmr) fetch-deps;
        };
      });

in
mkPackages {
  inherit vmr;
  fallbackTargetPackages = bootstrapSdk.targetPackages;
}
// {
  stage0 = lib.dontRecurseIntoAttrs stage0;
}
