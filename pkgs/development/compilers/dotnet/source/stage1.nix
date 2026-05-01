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
  mkVMR = callPackage ./vmr.nix;

  stage0 = callPackage ./stage0.nix (
    args
    // {
      baseName = "dotnet-stage0";
    }
  );

in
(mkVMR {
  inherit releaseManifestFile tarballHash;
  bootstrapSdk = stage0.sdk.unwrapped;
  hasRuntime = true;
}).overrideAttrs
  (old: {
    passthru = old.passthru or { } // {
      inherit stage0;
      inherit (stage0.vmr) fetch-drv fetch-deps;
    };
  })
