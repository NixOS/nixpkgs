import ./jdk-linux-base.nix {
  productVersion = "8";
  patchVersion = "73";
  downloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html;
  sha256_i686 = "1bi3yj2ds9w13p2lzvmxffk5gax8syi3bw52w8pam1jr3fmzgwgl";
  sha256_x86_64 = "1rp3nbnhkncyr48m0nn3pf5fr4bp3lzm0ki4gca7mn7rzag19a26";
  jceName = "jce_policy-8.zip";
  jceDownloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html;
  sha256JCE = "0n8b6b8qmwb14lllk2lk1q1ahd3za9fnjigz5xn65mpg48whl0pk";
}
