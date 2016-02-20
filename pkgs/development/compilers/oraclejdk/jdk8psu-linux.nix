import ./jdk-linux-base.nix {
  productVersion = "8";
  patchVersion = "74";
  downloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html;
  sha256_i686 = "1vc3g89fbrmznb10bhh5gs143hcjg4wsy4j4hwnr1djfj83y8188";
  sha256_x86_64 = "1pfx7il1h42w3kigscdvm9vfy616lmsp1d2cqvplim3nyxwmvz8b";
  jceName = "jce_policy-8.zip";
  jceDownloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html;
  sha256JCE = "0n8b6b8qmwb14lllk2lk1q1ahd3za9fnjigz5xn65mpg48whl0pk";
}
