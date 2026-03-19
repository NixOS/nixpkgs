{
  callPackage,
  dotnetCorePackages,
}:
callPackage ../dotnet.nix {
  releaseManifestFile = ./release.json;
  releaseInfoFile = ./release-info.json;
  bootstrapSdk = dotnetCorePackages.sdk_10_0_1xx;
  depsFile = ./deps.json;
  fallbackTargetPackages = dotnetCorePackages.sdk_10_0_2xx-bin.targetPackages;
}
