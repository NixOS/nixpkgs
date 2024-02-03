{ callPackage
, dotnetCorePackages
}: callPackage ../dotnet.nix {
  releaseManifestFile = ./release.json;
  releaseInfoFile = ./release-info.json;
  allowPrerelease = true;
  depsFile = ./deps.nix;
  bootstrapSdk = dotnetCorePackages.dotnet_9-bin.sdk;
}
