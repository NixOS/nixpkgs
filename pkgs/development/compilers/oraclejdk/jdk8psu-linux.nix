import ./jdk-linux-base.nix {
  productVersion = "8";
  patchVersion = "162";
  downloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html;
  sha256.i686-linux = "097vlvvj1vr7815rgarf5x97lagi4q0kai0x4lvd4y3wrzdqikzf";
  sha256.x86_64-linux = "0mq2d0lj53gzn4qqdjdgbwl0h857k2rnsnr2hkmvihnrgza85v38";
  sha256.armv7l-linux = "0xzsgdmpgs1n1g70hgly0mpxflhjrmq3vxwx8gl0kmqdiv4hqwjp";
  sha256.aarch64-linux = "19ykcsmvkf7sdq2lqwvyi60nhb8v7f88dqjycimrsar9y4r7skf8";
  jceName = "jce_policy-8.zip";
  jceDownloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html;
  sha256JCE = "0n8b6b8qmwb14lllk2lk1q1ahd3za9fnjigz5xn65mpg48whl0pk";
}
