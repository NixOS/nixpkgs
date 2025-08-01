{
  stdenv,
  lib,
  callPackage,

  releaseManifestFile,
  tarballHash,
  depsFile,
  bootstrapSdk,
  fallbackTargetPackages,
}@args:

let
  mkPackages = callPackage ./packages.nix;
  mkVMR = callPackage ./vmr.nix;

  stage0 = callPackage ./stage0.nix (
    args
    // {
      baseName = "dotnet-stage0";
    }
  );

  vmr =
    (mkVMR {
      inherit releaseManifestFile tarballHash;
      bootstrapSdk = stage0.sdk.unwrapped;
    }).overrideAttrs
      (old: {
        passthru = old.passthru or { } // {
          inherit (stage0.vmr) fetch-drv fetch-deps;
        };
      });

in
mkPackages {
  inherit vmr fallbackTargetPackages;
}
// {
  stage0 = lib.dontRecurseIntoAttrs stage0;
}
