import ./jdk-linux-base.nix {
  productVersion = "8";
  patchVersion = "25";
  downloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html;
  sha256_i686 = "17f396a541db09c732032185f10f9c6eb42ac7b5776814602342de9655b2e0e2";
  sha256_x86_64 = "057f660799be2307d2eefa694da9d3fce8e165807948f5bcaa04f72845d2f529";
  jceName = "jce_policy-8.zip";
  jceDownloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html;
  sha256JCE = "f3020a3922efd6626c2fff45695d527f34a8020e938a49292561f18ad1320b59";
}
