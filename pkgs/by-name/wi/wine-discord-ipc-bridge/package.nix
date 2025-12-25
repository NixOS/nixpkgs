{
  stdenvNoCC,
  pkgsCross,
  symlinkJoin,
}:
let
  innerDrv =
    if stdenvNoCC.hostPlatform.isLinux then
      pkgsCross.mingw32.callPackage ./unwrapped.nix { }
    else
      pkgsCross.mingwW64.callPackage ./unwrapped.nix {
        darwinSupport = stdenvNoCC.hostPlatform.isDarwin;
      };
in
symlinkJoin {
  name = "wine-discord-ipc-bridge-${innerDrv.version}";

  paths = [ innerDrv ];

  passthru.wine-discord-ipc-bridge = innerDrv;

  meta = {
    inherit (innerDrv.meta)
      description
      homepage
      license
      maintainers
      mainProgram
      ;
    platforms = [
      "i386-linux"
      "x86_64-linux"
      "x86_64-darwin"
    ];
  };
}
