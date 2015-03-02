{ stdenv, callPackage }:
callPackage ./makeRustcDerivation.nix {
  shortVersion = "1.0.0-dev";
  isRelease = false;
  # src rev for master on 2015/03/01
  srcRev = "157614249594f187f421cd97f928e64c5ab5c1fa";
  srcSha = "06d6fwl1dg6wfnwa002ak89hnjplpf2sjhg78yjg4ki0ca7b0b74";
  snapshotHashLinux686 = "3278ebbce8cb269acc0614dac5ddac07eab6a99c";
  snapshotHashLinux64 = "72287d0d88de3e5a53bae78ac0d958e1a7637d73";
  snapshotHashDarwin686 = "33b366b5287427a340a0aa6ed886d5ff4edf6a76";
  snapshotHashDarwin64 = "914bf9baa32081a9d5633f1d06f4d382cd71504e";
  snapshotDate = "2015-02-25";
  snapshotRev = "880fb89";
  patches = [
    ./patches/head.patch
  ] ++ stdenv.lib.optional stdenv.needsPax ./patches/grsec.patch;
}

