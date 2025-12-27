{
  pkgs,
  stdenv,
}:

if stdenv.hostPlatform.isDarwin then
  pkgs.callPackage ./darwin.nix { }
else if stdenv.hostPlatform.isLinux then
  pkgs.callPackage ./linux.nix { }
else
  throw "Unsupported platform: ${stdenv.hostPlatform.system}"
