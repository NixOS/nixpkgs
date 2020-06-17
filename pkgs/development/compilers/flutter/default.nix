{ callPackage }:

let
  mkFlutter = opts: callPackage (import ./flutter.nix opts) { };
  getPatches = dir:
    let files = builtins.attrNames (builtins.readDir dir);
    in map (f: dir + ("/" + f)) files;
in {
  stable = mkFlutter rec {
    pname = "flutter";
    channel = "stable";
    version = "1.17.3";
    filename = "flutter_linux_${version}-${channel}.tar.xz";
    sha256Hash = "16ymnphah0xqf9vn44syznmr66xbkdh4y75ynk7nr8aisrcdd81z";
    patches = getPatches ./patches/stable;
  };
  beta = mkFlutter rec {
    pname = "flutter-beta";
    channel = "beta";
    version = "1.19.0-4.1.pre";
    filename = "flutter_linux_${version}-${channel}.tar.xz";
    sha256Hash = "002aprwjx7wd79dy6rb61knddb8n23gwa5z8a9dydv0igjw50r32";
    patches = getPatches ./patches/beta;
  };
  dev = mkFlutter rec {
    pname = "flutter-dev";
    channel = "dev";
    version = "1.20.0-0.0.pre";
    filename = "flutter_linux_${version}-${channel}.tar.xz";
    sha256Hash = "1gjsvsw9wnfcip1hcm0dksgyp23jnvfl98gzj1dl1gyrqdrmj15b";
    patches = getPatches ./patches/beta;
  };
}
