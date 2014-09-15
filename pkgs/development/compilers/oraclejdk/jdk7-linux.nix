import ./jdk-linux-base.nix {
  productVersion = "7";
  patchVersion = "67";
  downloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html;
  sha256_i686 = "0p58pag1x85r911lxhmr4blk687ivjqigflx175vp7rcmmj108xn";
  sha256_x86_64 = "0db36jg08qy8712qy6lgyifdqlqb468rrnjm3aa6937ixl9ixpal";
  jceName = "UnlimitedJCEPolicyJDK7.zip";
  jceDownloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jce-7-download-432124.html;
  sha256JCE = "7a8d790e7bd9c2f82a83baddfae765797a4a56ea603c9150c87b7cdb7800194d";
}
