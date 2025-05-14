{ lib, buildDotnetGlobalTool }:
buildDotnetGlobalTool {
  pname = "upgrade-assistant";
  version = "0.5.1073";

  nugetHash = "sha256-kk3SIv1gp9xtof0MkGkNUiqGuXgy1+YMGxLFZPFsw+0=";

  meta = {
    homepage = "https://github.com/dotnet/upgrade-assistant";
    description = "Tool to assist developers in upgrading .NET Framework applications to .NET 6 and beyond";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
    mainProgram = "ugprade-assistant";
    platforms = lib.platforms.all;
  };
}
