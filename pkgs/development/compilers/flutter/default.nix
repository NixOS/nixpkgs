{ callPackage, dart }:
let
  mkFlutter = opts: callPackage (import ./flutter.nix opts) { };
  getPatches = dir:
    let files = builtins.attrNames (builtins.readDir dir);
    in map (f: dir + ("/" + f)) files;
in
{
  mkFlutter = mkFlutter;
  stable = mkFlutter rec {
    inherit dart;
    pname = "flutter";
    channel = "stable";
    version = "1.22.0";
    filename = "flutter_linux_${version}-${channel}.tar.xz";
    sha256Hash = "0ryrx458ss8ryhmspcfrhjvad2pl46bxh1qk5vzwzhxiqdc79vm8";
    patches = getPatches ./patches/stable;
  };
}
