{ callPackage
, dotnetCorePackages
}: callPackage ../dotnet.nix {
  releaseManifestFile = ./release.json;
  releaseInfoFile = ./release-info.json;
  bootstrapSdkFile = ./bootstrap-sdk.nix;
  depsFile = ./deps.json;
  fallbackTargetPackages = dotnetCorePackages.sdk_8_0.targetPackages;
}
