{
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  lib,
}:

buildDotnetModule (finalAttrs: {
  pname = "WiseUnpacker";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "mnadareski";
    repo = "WiseUnpacker";
    rev = finalAttrs.version;
    hash = "sha256-7TKXGI3XO4oLIZCD21xOpxD5bZKiI6Qk+pyLdzo+kQ8=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;

  dotnetFlags = [ "-p:TargetFramework=net10.0" ];

  nugetDeps = ./deps.json;

  projectFile = "WiseUnpacker/WiseUnpacker.csproj";

  executables = [ "WiseUnpacker" ];

  meta = {
    homepage = "https://github.com/mnadareski/WiseUnpacker/";
    description = "C# Wise installer unpacker based on HWUN and E_WISE ";
    maintainers = [ lib.maintainers.gigahawk ];
    license = lib.licenses.mit;
  };
})
