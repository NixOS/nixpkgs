{ stdenv, callPackage }:
callPackage ./generic.nix {
  shortVersion = "1.2.0";
  isRelease = true;
  srcSha = "1zq2nhgaxkv1ghi3z2qgff6cylqirn33nphvkjiczlkjfi0pyw16";

  /* Rust is bootstrapped from an earlier built version. We need
  to fetch these earlier versions, which vary per platform.
  The shapshot info you want can be found at
  https://github.com/rust-lang/rust/blob/{$shortVersion}/src/snapshots.txt
  with the set you want at the top.
  */

  # linux-i386
  snapshotHashLinux686 = "a6f22e481eabf098cc65bda97bf7e434a1fcc20b";

  # linux-x86_64
  snapshotHashLinux64 = "5fd8698fdfe953e6c4d86cf4fa1d5f3a0053248c";

  # macos-i386
  snapshotHashDarwin686 = "9a273324a6b63a40f67a553029c0a9fb692ffd1f";

  # macos-x86_64
  snapshotHashDarwin64 = "e5b12cb7c179fc98fa905a3c84803645d946a6ae";

  snapshotDate = "2015-05-24";
  snapshotRev = "ba0e1cd";

  patches = [
    ./patches/stable.patch
    ] ++ stdenv.lib.optional stdenv.needsPax ./patches/grsec.patch;
  configureFlags = [ "--release-channel=stable" ];
}
