{ lib, buildDotnetGlobalTool }:
buildDotnetGlobalTool {
  pname = "upgrade-assistant";
  version = "0.5.829";

  nugetHash = "sha256-N0xEmPQ88jfirGPLJykeAJQYGwELFzKwUWdFxIgiwhY=";

  meta = with lib; {
    homepage = "https://github.com/dotnet/upgrade-assistant";
    description = "Tool to assist developers in upgrading .NET Framework applications to .NET 6 and beyond";
    license = licenses.mit;
    maintainers = with maintainers; [ khaneliman ];
    mainProgram = "ugprade-assistant";
    platforms = platforms.all;
  };
}
