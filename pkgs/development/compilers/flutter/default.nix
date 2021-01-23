{ callPackage, dart }:
let
  dart_stable = dart.override { version = "2.10.0"; };
  dart_beta = dart.override { version = "2.10.0"; };
  dart_dev = dart.override { version = "2.11.0-161.0.dev"; };
  mkFlutter = opts: callPackage (import ./flutter.nix opts) { };
  getPatches = dir:
    let files = builtins.attrNames (builtins.readDir dir);
    in map (f: dir + ("/" + f)) files;
in
{
  mkFlutter = mkFlutter;
  stable = mkFlutter rec {
    pname = "flutter";
    channel = "stable";
    version = "1.22.0";
    filename = "flutter_linux_${version}-${channel}.tar.xz";
    sha256Hash = "0ryrx458ss8ryhmspcfrhjvad2pl46bxh1qk5vzwzhxiqdc79vm8";
    patches = getPatches ./patches/stable;
    dart = dart_stable;
  };
  beta = mkFlutter rec {
    pname = "flutter";
    channel = "beta";
    version = "1.22.0-12.3.pre";
    filename = "flutter_linux_${version}-${channel}.tar.xz";
    sha256Hash = "1axzz137z4lgpa09h7bjf52i6dij6a9wmjbha1182db23r09plzh";
    patches = getPatches ./patches/stable;
    dart = dart_beta;
  };
  dev = mkFlutter rec {
    pname = "flutter";
    channel = "dev";
    version = "1.23.0-7.0.pre";
    filename = "flutter_linux_${version}-${channel}.tar.xz";
    sha256Hash = "166qb4qbv051bc71yj7c0vrkamhvzz3fp3mz318qzm947mydwjj5";
    patches = getPatches ./patches/dev;
    dart = dart_dev;
  };
}
