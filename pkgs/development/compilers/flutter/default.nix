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
    version = "1.17.5";
    filename = "flutter_linux_${version}-${channel}.tar.xz";
    sha256Hash = "0kapja3nh7dfhjbn2np02wghijrjnpzsv4hz10fj54hs8hdx19di";
    patches = getPatches ./patches/stable;
  };
  beta = mkFlutter rec {
    pname = "flutter-beta";
    channel = "beta";
    version = "1.20.0-7.2.pre";
    filename = "flutter_linux_${version}-${channel}.tar.xz";
    sha256Hash = "0w89ig5vi4spa95mf08r4vvwni7bzzdlyhvr9sy1a35qmf7j9s6f";
    patches = getPatches ./patches/beta;
  };
  dev = mkFlutter rec {
    pname = "flutter-dev";
    channel = "dev";
    version = "1.21.0-1.0.pre";
    filename = "flutter_linux_${version}-${channel}.tar.xz";
    sha256Hash = "14rx89jp6ivk3ai7iwbznkr5q445ndh8fppzbxg520kq10s2208r";
    patches = getPatches ./patches/beta;
  };
}
