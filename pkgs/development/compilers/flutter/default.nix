{ callPackage, fetchurl, dart }:
let
  mkFlutter = opts: callPackage (import ./flutter.nix opts) { };
  getPatches = dir:
    let files = builtins.attrNames (builtins.readDir dir);
    in map (f: dir + ("/" + f)) files;
  version = "1.22.4";
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
      sha256 = "0qalgav9drqddcj8lfvl9ddf3325n953pvkmgha47lslg9sa88zw";
    };
    patches = getPatches ./patches;
  };
}
