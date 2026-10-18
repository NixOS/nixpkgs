{
  lib,
  runCommand,
  makeWrapper,
  sdk,
}:

runCommand "dotnet-workload-manifest-resolver-${sdk.version}"
  {
    nativeBuildInputs = [
      sdk
      makeWrapper
    ];
    propagatedSandboxProfile = toString sdk.__propagatedSandboxProfile;
  }
  ''
    cp ${./Program.cs} Program.cs
    cp ${./WorkloadManifestResolver.csproj} WorkloadManifestResolver.csproj
    mkdir empty-feed
    export HOME="$TMPDIR/home"
    mkdir -p "$HOME"
    dotnet build --nologo \
      -p:ResolverTargetFramework=net${lib.versions.majorMinor sdk.version} \
      -p:SDKDirectory=${sdk}/share/dotnet/sdk/${sdk.version} \
      --output "$out/lib"
    makeWrapper ${sdk}/bin/dotnet "$out/bin/dotnet-workload-manifest-resolver" \
      --add-flags "$out/lib/WorkloadManifestResolver.dll"
  ''
