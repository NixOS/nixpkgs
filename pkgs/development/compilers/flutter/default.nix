{ callPackage, fetchurl, dart }:
let
  mkFlutter = opts: callPackage (import ./flutter.nix opts) { };
  getPatches = dir:
    let files = builtins.attrNames (builtins.readDir dir);
    in map (f: dir + ("/" + f)) files;
  version = "3.3.3";
  channel = "stable";
  filename = "flutter_linux_${version}-${channel}.tar.xz";

  # Decouples flutter derivation from dart derivation,
  # use specific dart version to not need to bump dart derivation when bumping flutter.
  dartVersion = "2.18.2";
  dartSourceBase = "https://storage.googleapis.com/dart-archive/channels";
  dartForFlutter = dart.override {
    version = dartVersion;
    sources = {
      "${dartVersion}-x86_64-linux" = fetchurl {
        url = "${dartSourceBase}/stable/release/${dartVersion}/sdk/dartsdk-linux-x64-release.zip";
        sha256 = "sha256-C3+YjecXLvSmJrLwi9H7TgD9Np0AArRWx3EdBrfQpTU";
      };
    };
  };
in
{
  inherit mkFlutter;
  stable = mkFlutter rec {
    inherit version;
    dart = dartForFlutter;
    pname = "flutter";
    src = fetchurl {
      url = "https://storage.googleapis.com/flutter_infra_release/releases/${channel}/linux/${filename}";
      sha256 = "sha256-MTZeWQUp4/TcPzYIT6eqIKSPUPvn2Mp/thOQzNgpTXg=";
    };
    patches = getPatches ./patches;
  };
}
