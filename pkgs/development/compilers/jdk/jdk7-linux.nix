import ./jdk-linux-base.nix {
  productVersion = "7";
  patchVersion = "65";
  downloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html;
  sha256_i686 = "e3032c561deb237c033b485a358cc429ec83b621303bc6b31768855778a9eaa0";
  sha256_x86_64 = "33fac9630ca8c2d374247abc5c010ac8d2875a3384968aa3e74448361808e4b7";
  jceName = "UnlimitedJCEPolicyJDK7.zip";
  jceDownloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jce-7-download-432124.html;
  sha256JCE = "7a8d790e7bd9c2f82a83baddfae765797a4a56ea603c9150c87b7cdb7800194d";
}
