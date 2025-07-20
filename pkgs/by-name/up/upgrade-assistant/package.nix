{ lib, buildDotnetGlobalTool }:
buildDotnetGlobalTool {
  pname = "upgrade-assistant";
  version = "0.5.1165";

  nugetHash = "sha256-6LHGgpdCTiDaKZN5oWWUotH2SwExu9I1PAyt8TmQAh0=";

  meta = {
    homepage = "https://github.com/dotnet/upgrade-assistant";
    description = "Tool to assist developers in upgrading .NET Framework applications to .NET 6 and beyond";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
    mainProgram = "ugprade-assistant";
    platforms = lib.platforms.all;
  };
}
