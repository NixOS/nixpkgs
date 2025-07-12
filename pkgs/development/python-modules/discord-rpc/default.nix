{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "discord-rpc";
  version = "5.1";

  src = fetchPypi {
    inherit version;
    pname = "discord_rpc";
    hash = "sha256-y26HRewGV9G+rjTYfD5xgCUdze9n+reL1aqg5DcIxGg=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "discordrpc" ];

  meta = {
    description = "Python wrapper for the Discord RPC API";
    homepage = "https://github.com/Senophyx/Discord-RPC";
    changelog = "https://senophyx.id/projects/discord-rpc/#change-logs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nilathedragon ];
  };
}
