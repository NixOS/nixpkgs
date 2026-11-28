{
  lib,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  nix-update-script,
}:

buildDotnetModule (finalAttrs: {
  pname = "wiseunpacker";
  version = "3.1.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "mnadareski";
    repo = "WiseUnpacker";
    tag = finalAttrs.version;
    hash = "sha256-7TKXGI3XO4oLIZCD21xOpxD5bZKiI6Qk+pyLdzo+kQ8=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;

  dotnetFlags = [ "-p:TargetFramework=net10.0" ];

  nugetDeps = ./deps.json;

  projectFile = "WiseUnpacker/WiseUnpacker.csproj";

  executables = [ "WiseUnpacker" ];

  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/mnadareski/WiseUnpacker/";
    changelog = "https://github.com/mnadareski/WiseUnpacker/releases/tag/${finalAttrs.src.tag}";
    description = "Wise installer unpacker based on REWise";
    maintainers = [ lib.maintainers.gigahawk ];
    mainProgram = "WiseUnpacker";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode # libGrindCore from NuGet
    ];
  };
})
