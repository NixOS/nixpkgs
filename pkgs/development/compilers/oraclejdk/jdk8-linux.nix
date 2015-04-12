import ./jdk-linux-base.nix {
  productVersion = "8";
  patchVersion = "40";
  downloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html;
  sha256_i686 = "9300846c8ced85d14b9dd8ec5ec379a0af982c589cf6d149ee09d972fe6729b0";
  sha256_x86_64 = "da1ad819ce7b7ec528264f831d88afaa5db34b7955e45422a7e380b1ead6b04d";
  jceName = "jce_policy-8.zip";
  jceDownloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html;
  sha256JCE = "0n8b6b8qmwb14lllk2lk1q1ahd3za9fnjigz5xn65mpg48whl0pk";
}
