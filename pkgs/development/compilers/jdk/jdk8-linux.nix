import ./jdk-linux-base.nix {
  productVersion = "8";
  patchVersion = "5";
  downloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html;
  sha256_i686 = "779f83efb8dc9ce7c1143ba9bbd38fa2d8a1c49dcb61f7d36972d37d109c5fc9";
  sha256_x86_64 = "44901389e9fb118971534ad0f58558ba8c43f315b369117135bd6617ae631edc";
  jceName = "jce_policy-8.zip";
  jceDownloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html;
  sha256JCE = "f3020a3922efd6626c2fff45695d527f34a8020e938a49292561f18ad1320b59";
}
