{
  callPackage,
  useWheel ? true,
}@pkgs:
callPackage (if useWheel then (import ./build-wheel.nix) else (import ./build-native.nix)) { }
