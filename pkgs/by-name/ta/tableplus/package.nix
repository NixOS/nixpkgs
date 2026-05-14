{
  callPackage,
  stdenv,
}:

if stdenv.hostPlatform.isDarwin then
  callPackage ./darwin.nix { }
else if stdenv.hostPlatform.isLinux then
  callPackage ./linux.nix { }
else
  throw "Unsupported platform: ${stdenv.hostPlatform.system}"
