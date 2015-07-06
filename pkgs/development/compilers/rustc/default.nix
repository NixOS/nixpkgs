{ stdenv, callPackage }:
callPackage ./generic.nix {
  shortVersion = "1.1.0";
  isRelease = true;
  srcSha = "0lsfrclj5imxy6129ggya7rb2h04cgqq53f75z2jv40y5xk25sy8";

  /* Rust is bootstrapped from an earlier built version. We need
  to fetch these earlier versions, which vary per platform.
  The shapshot info you want can be found at
  https://github.com/rust-lang/rust/blob/{$shortVersion}/src/snapshots.txt
  with the set you want at the top.
  */

  # linux-i386
  snapshotHashLinux686 = "0bc8cffdce611fb71fd7d3d8e7cdbfaf748a4f16";

  # linux-x86_64
  snapshotHashLinux64 = "94089740e48167c5975c92c139ae9c286764012f";

  # macos-i386
  snapshotHashDarwin686 = "54cc35e76497e6e94fddf38d6e40e9d168491ddb";

  # macos-x86_64
  snapshotHashDarwin64 = "43a1c1fba0d1dfee4c2ca310d506f8f5f51b3f6f";

  snapshotDate = "2015-04-27";
  snapshotRev = "857ef6e";

  patches = [
    ./patches/beta.patch
    ] ++ stdenv.lib.optional stdenv.needsPax ./patches/grsec.patch;
  configureFlags = [ "--release-channel=stable" ];
}
