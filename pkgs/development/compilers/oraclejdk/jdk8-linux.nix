import ./jdk-linux-base.nix {
  productVersion = "8";
  patchVersion = "40";
  downloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html;
  sha256_i686 = "a0f035c234eea71656ee989b8a569c901f7912ec969f1147771364b5aa5dcaad";
  sha256_x86_64 = "c66029684bb8aa0c0eaea7b4d21de00e36a43dcc5a82f6666d489fd27027d559";
  jceName = "jce_policy-8.zip";
  jceDownloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html;
  sha256JCE = "f3020a3922efd6626c2fff45695d527f34a8020e938a49292561f18ad1320b59";
}
