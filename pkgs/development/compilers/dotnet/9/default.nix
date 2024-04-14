{ callPackage
, dotnetCorePackages
}: callPackage ../dotnet.nix {
  releaseManifestFile = ./release.json;
  releaseInfoFile = ./release-info.json;
  allowPrerelease = true;
  depsFile = ./deps.nix;
  bootstrapSdk = dotnetCorePackages.sdk_9_0;
}
