{
  lib,
  symlinkJoin,
  tdarr-server,
  tdarr-node,
}:

symlinkJoin {
  name = "tdarr-${tdarr-server.version}";
  pname = "tdarr";
  inherit (tdarr-server) version;

  paths = [
    tdarr-server
    tdarr-node
  ];

  passthru = {
    server = tdarr-server;
    node = tdarr-node;
  };

  meta = {
    description = "Distributed transcode automation using FFmpeg/HandBrake (includes both server and node)";
    homepage = "https://tdarr.io";
    license = lib.licenses.unfree;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    maintainers = with lib.maintainers; [ mistyttm ];
  };
}
