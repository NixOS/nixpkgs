import ./jdk-linux-base.nix {
  productVersion = "8";
  patchVersion = "112";
  downloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html;
  sha256_i686 = "19b9vwb7bd17s9p04y47zzjkccazzmpy4dqx4rgxd79k1fw2yz0y";
  sha256_x86_64 = "19blsx81x5p2f6d9vig89z7cc8778cp6qdjy9ylsa2444vaxfyvp";
  jceName = "jce_policy-8.zip";
  jceDownloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html;
  sha256JCE = "0n8b6b8qmwb14lllk2lk1q1ahd3za9fnjigz5xn65mpg48whl0pk";
}
