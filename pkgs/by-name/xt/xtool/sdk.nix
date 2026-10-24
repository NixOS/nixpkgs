{
  lib,
  runCommand,
  darwin,
  jq,
  swift,
  xtool,
  # This should be kept in sync with the Swift version in Nixpkgs.
  xcode ? darwin.xcode_27_1,
}:

runCommand "xtool-darwin-sdk-${xcode.version}"
  {
    nativeBuildInputs = [
      jq
      swift
      xtool
    ];
    meta = {
      description = "Darwin Swift SDK built by xtool from Xcode";
      longDescription = ''
        Enable `programs.xtool.sdk.enable` on NixOS, or link this to
        `$XDG_CONFIG_HOME/swiftpm/swift-sdks/darwin.artifactbundle`
        (`~/.swiftpm/swift-sdks/darwin.artifactbundle` if it is unset).
        Builds that use `xtoolBuildHook` link this SDK automatically.
      '';
      homepage = "https://xtool.sh";
      license = lib.licenses.unfree;
      sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
      inherit (xtool.meta) maintainers;
      platforms = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      hydraPlatforms = [ ];
    };
  }
  ''
    xtool sdk build ${xcode} "$TMPDIR"
    mv "$TMPDIR/darwin.xtoolsdk" "$out"

    # headers xtool sdk install would add from the host Swift toolchain
    resources=$(swiftc -print-target-info | jq -r .paths.runtimeResourcePath)
    cp -r "$resources/clang/include" "$out/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/clang/include"
  ''
