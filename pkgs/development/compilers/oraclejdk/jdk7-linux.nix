import ./jdk-linux-base.nix {
  productVersion = "7";
  patchVersion = "75";
  downloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html;
  sha256_i686 = "173ppi5d90hllqgys90wlv596bpj2iw8gsbsr6pk7xvd4l1wdhrw";
  sha256_x86_64 = "040n50nglr6rcli2pz5rd503c2qqdqqbqynp6hzc4kakkchmj2a6";
  jceName = "UnlimitedJCEPolicyJDK7.zip";
  jceDownloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jce-7-download-432124.html;
  sha256JCE = "7a8d790e7bd9c2f82a83baddfae765797a4a56ea603c9150c87b7cdb7800194d";
}
