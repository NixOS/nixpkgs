import ./jdk-linux-base.nix {
  productVersion = "8";
  patchVersion = "162";
  downloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html;
  sha256_i686 = "097vlvvj1vr7815rgarf5x97lagi4q0kai0x4lvd4y3wrzdqikzf";
  sha256_x86_64 = "0mq2d0lj53gzn4qqdjdgbwl0h857k2rnsnr2hkmvihnrgza85v38";
  sha256_armv7l = "0xzsgdmpgs1n1g70hgly0mpxflhjrmq3vxwx8gl0kmqdiv4hqwjp";
  jceName = "jce_policy-8.zip";
  jceDownloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html;
  sha256JCE = "0n8b6b8qmwb14lllk2lk1q1ahd3za9fnjigz5xn65mpg48whl0pk";
}
