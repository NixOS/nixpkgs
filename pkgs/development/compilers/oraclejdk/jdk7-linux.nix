import ./jdk-linux-base.nix {
  productVersion = "7";
  patchVersion = "79";
  downloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html;
  sha256_i686 = "1hv9bmj08y8gavhhkip5w5dg96b1dy4sc2cidpjcbwpb2mzh5lhs";
  sha256_x86_64 = "140xl5kfdrlmh8wh2x3j23x53dbil8qxsvc7gf3138mz4805vmr9";
  jceName = "UnlimitedJCEPolicyJDK7.zip";
  jceDownloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jce-7-download-432124.html;
  sha256JCE = "7a8d790e7bd9c2f82a83baddfae765797a4a56ea603c9150c87b7cdb7800194d";
  broken = true;
}
