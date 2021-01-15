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
    version = "1.22.4";
    sha256Hash = "0qalgav9drqddcj8lfvl9ddf3325n953pvkmgha47lslg9sa88zw";
    patches = getPatches ./patches/stable;
  };
}
