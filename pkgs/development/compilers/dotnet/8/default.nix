{ callPackage
, dotnetCorePackages
}: callPackage ../dotnet.nix {
  releaseManifestFile = ./release.json;
  releaseInfoFile = ./release-info.json;
  bootstrapSdkFile = ./bootstrap-sdk.nix;
  depsFile = ./deps.nix;
  fallbackTargetPackages = dotnetCorePackages.sdk_8_0.targetPackages;
}
