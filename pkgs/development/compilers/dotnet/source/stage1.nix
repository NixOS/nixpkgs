{
  stdenv,
  lib,
  callPackage,

  releaseManifestFile,
  tarballHash,
  depsFile,
  bootstrapSdk,
  pkgsBuildBuild,
}@args:

let
  mkVMR = callPackage ./vmr.nix;

  stage0 = pkgsBuildBuild.dotnetCorePackages.callPackage ./stage0.nix (
    {
      inherit (args)
        releaseManifestFile
        tarballHash
        depsFile
        bootstrapSdk
        ;
    }
    // {
      baseName = "dotnet-stage0";
    }
  );

in
(mkVMR {
  inherit releaseManifestFile tarballHash;
  bootstrapSdk = stage0.sdk;
  hasRuntime = true;
}).overrideAttrs
  (old: {
    passthru = old.passthru or { } // {
      inherit stage0;
      inherit (stage0.vmr) fetch-drv fetch-deps;
    };
  })
