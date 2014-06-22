import ./jdk-linux-base.nix {
  productVersion = "7";
  patchVersion = "60";
  downloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html;
  sha256_i686 = "d736fb4fd7c8ef50b76411daa640c6feeb48a5c275d29a90ffeb916a78d47a48";
  sha256_x86_64 = "c7232b717573b057dbe828d937ee406b7a75fbc6aba7f1de98a049cbd42c6ae8";
  jceName = "UnlimitedJCEPolicyJDK7.zip";
  jceDownloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jce-7-download-432124.html;
  sha256JCE = "7a8d790e7bd9c2f82a83baddfae765797a4a56ea603c9150c87b7cdb7800194d";
}
