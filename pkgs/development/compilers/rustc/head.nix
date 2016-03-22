# Please make sure to check if rustfmt still builds when updating nightly
{ stdenv, callPackage }:

callPackage ./generic.nix {
  shortVersion = "2016-03-22";
  isRelease = false;
  forceBundledLLVM = true;
  srcRev = "6cc502c986d42da407e26a49d4f09f21d3072fcb";
  srcSha = "096lsc8irh9a7w494yaji28kzy9frs2myqrfyj0fzbxkvs3yfhzz";

  /* Rust is bootstrapped from an earlier built version. We need
  to fetch these earlier versions, which vary per platform.
  The shapshot info you want can be found at
  https://github.com/rust-lang/rust/blob/{$shortVersion}/src/snapshots.txt
  with the set you want at the top.
  */

  snapshotHashLinux686 = "0e0e4448b80d0a12b75485795244bb3857a0a7ef";
  snapshotHashLinux64 = "1273b6b6aed421c9e40c59f366d0df6092ec0397";
  snapshotHashDarwin686 = "9f9c0b4a2db09acbce54b792fb8839a735585565";
  snapshotHashDarwin64 = "52570f6fd915b0210a9be98cfc933148e16a75f8";
  snapshotDate = "2016-03-18";
  snapshotRev = "235d774";

  patches = [ ./patches/remove-uneeded-git.patch ]
    ++ stdenv.lib.optional stdenv.needsPax ./patches/grsec.patch;
}
