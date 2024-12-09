{ callPackage
, dotnetCorePackages
}: callPackage ../dotnet.nix {
  releaseManifestFile = ./release.json;
  releaseInfoFile = ./release-info.json;
  bootstrapSdkFile = ./bootstrap-sdk.nix;
  allowPrerelease = true;
  depsFile = ./deps.nix;
  fallbackTargetPackages = dotnetCorePackages.sdk_9_0.targetPackages;
}
