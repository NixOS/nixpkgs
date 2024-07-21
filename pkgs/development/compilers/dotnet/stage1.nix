{ stdenv
, lib
, callPackage
, pkgsBuildHost

, releaseManifestFile
, tarballHash
, depsFile
, bootstrapSdk
}@args:

let
  mkPackages = callPackage ./packages.nix;
  mkVMR = callPackage ./vmr.nix;

  stage0 = pkgsBuildHost.callPackage ./stage0.nix args;

  vmr = (mkVMR {
    inherit releaseManifestFile tarballHash;
    dotnetSdk = stage0.sdk;
  }).overrideAttrs (old: {
    passthru = old.passthru or {} // {
      inherit (stage0.vmr) fetch-deps;
    };
  });

in mkPackages { inherit vmr; }
