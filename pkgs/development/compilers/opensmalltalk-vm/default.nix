{ stdenv, lib, callPackage }:
let
  vmData = import ./vms.nix;
  buildVM = callPackage ./build-vm.nix { };
  vmDerivs = builtins.mapAttrs
    (platformDir: vms:
      lib.mapAttrs'
        (vmName: args: {
          name = builtins.replaceStrings [ "." ] [ "-" ] vmName;
          value = buildVM ({ inherit platformDir vmName; } // args);
        })
        vms)
    vmData;
in
if stdenv.targetPlatform.system == "aarch64-linux" then vmDerivs."linux64ARMv8"
else if stdenv.targetPlatform.system == "x86_64-linux" then vmDerivs."linux64x64"
else
  throw "Unsupported platform: only the following platforms are supported.
    - aarch64-linux
    - x86_64-linux
  "
