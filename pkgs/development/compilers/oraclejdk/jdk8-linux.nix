import ./jdk-linux-base.nix {
  productVersion = "8";
  patchVersion = "20";
  downloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html;
  sha256_i686 = "fa013b3fcbb1308040bf0e75bbd6ef7e8396b547cbc8dd79e3cb8153604bfd06";
  sha256_x86_64 = "3e717622ae48af5ca7298e7797cb71d4d545238f362741a83e69c097ca055de4";
  jceName = "jce_policy-8.zip";
  jceDownloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html;
  sha256JCE = "f3020a3922efd6626c2fff45695d527f34a8020e938a49292561f18ad1320b59";
}
