{
  lib,
  cctools,
  jq,
  llvmPackages_upstream,
  llvm_libtool,
  makeSetupHook,
  stdenv,
  stdenvNoCC,
  swiftpm,
  swiftpmUnpackHook,
}:

let
  vtool = stdenvNoCC.mkDerivation {
    pname = "cctools-vtool";
    version = lib.getVersion cctools;

    buildCommand = ''
      mkdir -p "$out/bin"
      ln -s ${lib.getExe' cctools "vtool"} "$out/bin/vtool"
    '';
  };
in

makeSetupHook {
  name = "${lib.getName swiftpm}-hook-${lib.getVersion swiftpm}";
  propagatedBuildInputs = [
    swiftpmUnpackHook
  ]
  ++ lib.optionals stdenvNoCC.hostPlatform.isDarwin [
    # SwiftPM requires these tools for builds on Darwin.
    # It also requires xcrun, which is already part of the Darwin stdenv.
    llvm_libtool
    vtool
  ];
  substitutions = {
    inherit (stdenvNoCC.hostPlatform.extensions) sharedLibrary;
    swiftPlatform = stdenv.hostPlatform.swift.platform;
    install_name_tool = lib.getExe' llvmPackages_upstream.llvm "llvm-install-name-tool";
    jq = lib.getExe jq;
  };
} ./setup-hook.sh
