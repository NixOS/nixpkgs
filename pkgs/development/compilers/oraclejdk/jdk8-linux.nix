import ./jdk-linux-base.nix {
  productVersion = "8";
  patchVersion = "60";
  downloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html;
  sha256_i686 = "e6a36b458351ed35bd7943739ba93d9a246e08a86433e148ff68b1b40d74c2e5";
  sha256_x86_64 = "ebe51554d2f6c617a4ae8fc9a8742276e65af01bd273e96848b262b3c05424e5";
  jceName = "jce_policy-8.zip";
  jceDownloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html;
  sha256JCE = "0n8b6b8qmwb14lllk2lk1q1ahd3za9fnjigz5xn65mpg48whl0pk";
}
