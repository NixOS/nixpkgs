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

  postPatch = ''
    # set the build timestamp to $SOURCE_DATE_EPOCH
    substituteInPlace src/Zilf/Zilf.csproj \
        --replace-fail '$(_BuildTimeUtc)' "$(date -u -d "@$SOURCE_DATE_EPOCH" '+%Y-%m-%dT%H:%M:%S.%NZ')"
  '';

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
    mainProgram = "zilf";
    homepage = "https://zilf.io/";
    maintainers = with lib.maintainers; [
      marcin-serwin
    ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Plus;
  };
})
