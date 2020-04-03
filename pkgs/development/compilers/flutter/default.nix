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
    version = "1.12.13+hotfix.8";
    sha256Hash = "01ik4xckr3fp65sq4g0g6wy5b9i0r49l643xmbxa6z9k21sby46d";
    patches = getPatches ./patches/stable;
  };
  beta = mkFlutter {
    pname = "flutter-beta";
    channel = "beta";
    version = "1.14.6";
    sha256Hash = "1a79pr741zkr39p5gc3p9x59d70vm60hpz2crgc53ysglj4ycigy";
    patches = getPatches ./patches/beta;
  };
  dev = mkFlutter {
    pname = "flutter-dev";
    channel = "dev";
    version = "1.15.3";
    sha256Hash = "06mawwqf7q7wdmzlyxlrlblhnnk4ckf3vp92lplippdh3d52r93i";
    patches = getPatches ./patches/dev;
  };
}
