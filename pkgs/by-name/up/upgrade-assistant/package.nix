{ lib, buildDotnetGlobalTool }:
buildDotnetGlobalTool {
  pname = "upgrade-assistant";
  version = "0.5.1084";

  nugetHash = "sha256-O+HHLqou6hRAQ8vUzq+VfX0vRM+nZGPnfCg8niYX2gE=";

  meta = {
    homepage = "https://github.com/dotnet/upgrade-assistant";
    description = "Tool to assist developers in upgrading .NET Framework applications to .NET 6 and beyond";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
    mainProgram = "ugprade-assistant";
    platforms = lib.platforms.all;
  };
}
