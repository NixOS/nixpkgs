{ callPackage, fetchurl, dart }:
let
  mkFlutter = opts: callPackage (import ./flutter.nix opts) { };
  getPatches = dir:
    let files = builtins.attrNames (builtins.readDir dir);
    in map (f: dir + ("/" + f)) files;
  version = "2.0.3";
  channel = "stable";
  filename = "flutter_linux_${version}-${channel}.tar.xz";
in
{
  mkFlutter = mkFlutter;
  stable = mkFlutter rec {
    inherit dart version;
    pname = "flutter";
    src = fetchurl {
      url = "https://storage.googleapis.com/flutter_infra/releases/${channel}/linux/${filename}";
      sha256 = "14a63cpkp78rgymmlrppds69jsrdarg33dr43nb7s61r0xfh9icm";
    };
    patches = getPatches ./patches;
  };
}
