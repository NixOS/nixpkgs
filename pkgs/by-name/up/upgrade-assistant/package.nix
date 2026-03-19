{ lib, buildDotnetGlobalTool }:
buildDotnetGlobalTool {
  pname = "upgrade-assistant";
  version = "1.0.518";

  nugetHash = "sha256-VpesxikW1it/j/Wh4xj5Qj7mdfsgLljTuTJd2IzCHTk=";

  meta = {
    homepage = "https://github.com/dotnet/upgrade-assistant";
    description = "Tool to assist developers in upgrading .NET Framework applications to .NET 6 and beyond";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
    mainProgram = "ugprade-assistant";
    platforms = lib.platforms.all;
  };
}
