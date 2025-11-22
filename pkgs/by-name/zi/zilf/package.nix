{
  lib,
  buildDotnetModule,
  fetchFromGitLab,
  dotnetCorePackages,
}:
buildDotnetModule (finalAttrs: {
  pname = "zilf";
  version = "0.11.1";

  src = fetchFromGitLab {
    domain = "foss.heptapod.net";
    owner = "zilf";
    repo = "zilf";
    tag = finalAttrs.version;
    hash = "sha256-xcTxHC5LfO6UqDSkZqkM2p9F6VXvvp8Ru12kBVs31bU=";
  };

  selfContainedBuild = true;

  dotnet-sdk = dotnetCorePackages.sdk_9_0;
  dotnet-runtime = dotnetCorePackages.runtime_9_0;
  nugetDeps = ./deps.json;

  projectFile = [
    "src/Zilf/Zilf.csproj"
    "src/Zapf/Zapf.csproj"
    "src/Dezapf/Dezapf.csproj"
  ];
  executables = [
    "zilf"
    "zapf"
    "Dezapf"
  ];

  meta = {
    description = "Set of tools for working with the ZIL interactive fiction language, including a compiler, assembler, disassembler, and game library";
    homepage = "https://zilf.io/";
    maintainers = with lib.maintainers; [
      marcin-serwin
    ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Plus;
  };
})
