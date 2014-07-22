import ./jdk-linux-base.nix {
  productVersion = "8";
  patchVersion = "11";
  downloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html;
  sha256_i686 = "3981e6fb7d35b20ac3c05ec56fb3798ac1cd872a9e968bb3d77a718af7b146d1";
  sha256_x86_64 = "f3593b248b64cc53bf191f45b92a1f10e8c5099c2f84bd5bd5d6465dfd07a8e9";
  jceName = "jce_policy-8.zip";
  jceDownloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html;
  sha256JCE = "f3020a3922efd6626c2fff45695d527f34a8020e938a49292561f18ad1320b59";
}
