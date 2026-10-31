{
  lib,
  callPackage,
  symlinkJoin,
}:

let
  server = callPackage ./server.nix { };
  node = callPackage ./node.nix { };
in
symlinkJoin {
  name = "tdarr-${server.version}";
  pname = "tdarr";
  inherit (server) version;

  paths = [
    server
    node
  ];

  passthru = {
    inherit server node;
    tests = server.tests or { } // node.tests or { };

    # Server and node share one version.
    updateScript = {
      command = [ ./update-hashes.sh ];
      supportedFeatures = [ "commit" ];
    };
  };

  meta = {
    description = "Distributed transcode automation using FFmpeg/HandBrake (includes both server and node)";
    homepage = "https://tdarr.io";
    license = lib.licenses.unfree;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    maintainers = with lib.maintainers; [ mistyttm ];
  };
}
