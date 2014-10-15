import ./jdk-linux-base.nix {
  productVersion = "7";
  patchVersion = "72";
  downloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html;
  sha256_i686 = "0376c8a0280752b4389b6cb193d463826c55c821587d0278b7fea665a140f407";
  sha256_x86_64 = "dd1d438e1b7d4b9bb5ea4659f2103b577d1568da51b53f97b736b3232eeade8e";
  jceName = "UnlimitedJCEPolicyJDK7.zip";
  jceDownloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jce-7-download-432124.html;
  sha256JCE = "7a8d790e7bd9c2f82a83baddfae765797a4a56ea603c9150c87b7cdb7800194d";
}
