{
  lib,
  stdenvNoCC,
  callPackage,
  targetPlatform,
  version,
  bootstrapHashes ? { },
}:
stdenvNoCC.mkDerivation (
  finalAttrs:
  let
    common = callPackage ./common.nix {
      inherit (finalAttrs) pname version;
      zig = finalAttrs.finalPackage;
    };

    platform = "${
      if targetPlatform.isDarwin then "macos" else targetPlatform.parsed.kernel.name
    }-${targetPlatform.parsed.cpu.name}";
  in
  {
    pname = "zig-bootstrap";
    inherit version;

    bootstrap = builtins.fetchTarball {
      url = "https://ziglang.org/${
        if lib.versionOlder finalAttrs.version "0.12" then "download/${finalAttrs.version}" else "builds"
      }/zig-${platform}-${finalAttrs.version}.tar.xz";
      sha256 = bootstrapHashes."${platform}" or (throw "Unsupported platform ${platform}");
    };

    dontUnpack = true;
    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      mkdir -p $out/bin
      ln -s $bootstrap/zig $out/bin/zig
      ln -s $bootstrap/lib $out/lib
    '';

    inherit (common) passthru meta;
  }
)
