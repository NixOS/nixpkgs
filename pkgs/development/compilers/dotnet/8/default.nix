{ callPackage
, dotnetCorePackages
, bootstrapSdk
}: callPackage ../dotnet.nix {
  releaseManifestFile = ./release.json;
  releaseInfoFile = ./release-info.json;
  depsFile = ./deps.nix;
  inherit bootstrapSdk;
}
