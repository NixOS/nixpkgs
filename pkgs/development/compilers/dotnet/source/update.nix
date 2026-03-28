{
  stdenvNoCC,
  lib,
  fetchurl,
  writeScript,
  nix,
  runtimeShell,
  curl,
  cacert,
  jq,
  yq,
  gnupg,
  replaceVarsWith,

  releaseManifestFile,
  releaseInfoFile,
  bootstrapSdkFile,
  allowPrerelease,
}:

let
  inherit (lib.importJSON releaseManifestFile) channel tag sdkVersion;

  # version including up to the sdk feature band
  sdkVersionPrefix =
    let
      parts = lib.take 3 (lib.splitVersion sdkVersion);
      patch = lib.elemAt parts 2;
      band = lib.substring 0 (lib.stringLength patch - 2) patch;
    in
    lib.concatStringsSep "." (lib.replaceElemAt parts 2 band);

  pkg = stdenvNoCC.mkDerivation {
    name = "update-dotnet-vmr-env";

    nativeBuildInputs = [
      nix
      curl
      cacert
      jq
      yq
      gnupg
    ];
  };

  releaseKey = fetchurl {
    url = "https://dotnet.microsoft.com/download/dotnet/release-key-2023.asc";
    hash = "sha256-F668QB55md0GQvoG0jeA66Fb2RbrsRhFTzTbXIX3GUo=";
  };

  drv = builtins.unsafeDiscardOutputDependency pkg.drvPath;

  toOutputPath =
    path:
    let
      root = ../../../..;
    in
    lib.path.removePrefix root path;

in
replaceVarsWith {
  src = ./update-dotnet-vmr.sh;

  replacements = {
    inherit
      nix
      runtimeShell
      drv
      sdkVersionPrefix
      tag
      releaseKey
      ;
    prereleaseExpr = lib.optionalString (!allowPrerelease) ".prerelease == false and";
    dotnetBuildUrl =
      "https://builds.dotnet.microsoft.com/"
      + (
        if lib.versionAtLeast channel "10" then "dotnet/source-build" else "source-built-artifacts/assets"
      );
    releaseManifestFile = toOutputPath releaseManifestFile;
    releaseInfoFile = toOutputPath releaseInfoFile;
    updateScript = lib.escapeShellArg (toOutputPath ./update.sh);
    bootstrapSdkFile = lib.escapeShellArg (lib.mapNullable toOutputPath bootstrapSdkFile);
  };

  isExecutable = true;
}
