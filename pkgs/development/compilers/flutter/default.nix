{ callPackage }:

let
  mkFlutter = opts: callPackage (import ./flutter.nix opts) { };
  getPatches = dir:
    let files = builtins.attrNames (builtins.readDir dir);
    in map (f: dir + ("/" + f)) files;
in {
  stable = mkFlutter {
    pname = "flutter";
    channel = "stable";
    version = "1.17.5";
    sha256Hash = "0kapja3nh7dfhjbn2np02wghijrjnpzsv4hz10fj54hs8hdx19di";
    patches = getPatches ./patches/stable;
  };
  beta = mkFlutter {
    pname = "flutter-beta";
    channel = "beta";
    version = "1.19.0-4.3.pre";
    sha256Hash = "1hlkvvcfy53g69qnqq29izh5c0ylmx4w9m5kb78x97yld6jzf37p";
    patches = getPatches ./patches/beta;
  };
  dev = mkFlutter {
    pname = "flutter-dev";
    channel = "dev";
    version = "1.20.0-7.1.pre";
    sha256Hash = "1si83xgwkfn6fnwb12xk2cl4wm8cf0pf3m3jrg2jy2b5wmdr36kd";
    patches = getPatches ./patches/beta;
  };
}
