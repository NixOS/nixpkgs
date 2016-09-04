import ./jdk-linux-base.nix {
  productVersion = "8";
  patchVersion = "102";
  downloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html;
  sha256_i686 = "1bsypgf9va8jds0rlpnwp9n9p11hz77gqlmb0b0w2qwfmlmi227d";
  sha256_x86_64 = "1dq4kqi8k2k11sc28fnbp6cmncfj86jv57iy1gkap94i0fyf1yvw";
  jceName = "jce_policy-8.zip";
  jceDownloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html;
  sha256JCE = "0n8b6b8qmwb14lllk2lk1q1ahd3za9fnjigz5xn65mpg48whl0pk";
}
