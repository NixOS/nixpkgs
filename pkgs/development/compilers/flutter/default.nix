{ callPackage, fetchurl, dart }:
let
  mkFlutter = opts: callPackage (import ./flutter.nix opts) { };
  getPatches = dir:
    let files = builtins.attrNames (builtins.readDir dir);
    in map (f: dir + ("/" + f)) files;
  version = "2.2.1";
  dartVersion = "2.13.1";
  channel = "stable";
  filename = "flutter_linux_${version}-${channel}.tar.xz";
  dartStable = dart.override {
    version = dartVersion;
    sources = {
      "${dartVersion}-x86_64-darwin" = fetchurl {
        url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${dartVersion}/sdk/dartsdk-macos-x64-release.zip";
        sha256 = "0kb6r2rmp5d0shvgyy37fmykbgww8qaj4f8k79rmqfv5lwa3izya";
      };
      "${dartVersion}-x86_64-linux" = fetchurl {
        url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${dartVersion}/sdk/dartsdk-linux-x64-release.zip";
        sha256 = "0zq8wngyrw01wjc5s6w1vz2jndms09ifiymjjixxby9k41mr6jrq";
      };
      "${dartVersion}-i686-linux" = fetchurl {
        url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${dartVersion}/sdk/dartsdk-linux-ia32-release.zip";
        sha256 = "0zv4q8xv2i08a6izpyhhnil75qhs40m5mgyvjqjsswqkwqdf7lkj";
      };
      "${dartVersion}-aarch64-linux" = fetchurl {
        url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${dartVersion}/sdk/dartsdk-linux-arm64-release.zip";
        sha256 = "0bb9jdmg5p608jmmiqibp13ydiw9avgysxlmljvgsl7wl93j6rgc";
      };
    };
  };
in
{
  mkFlutter = mkFlutter;
  stable = mkFlutter rec {
    dart = dartStable;
    inherit version;
    pname = "flutter";
    src = fetchurl {
      url = "https://storage.googleapis.com/flutter_infra/releases/${channel}/linux/${filename}";
      sha256 = "009pwk2casz10gibgjpz08102wxmkq9iq3994b3c2q342g6526g0";
    };
    patches = getPatches ./patches;
  };
}
