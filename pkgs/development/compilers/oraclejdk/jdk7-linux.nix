import ./jdk-linux-base.nix {
  productVersion = "7";
  patchVersion = "72";
  downloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html;
  sha256_i686 = "01zl82hnb9pynxw04zaq4745av42cga97cbckcwb8lh752hchxh3";
  sha256_x86_64 = "13nyx8p27crnnybkzdaiv9l1azap7c8g4na6xasrnjvx3f7467fx";
  jceName = "UnlimitedJCEPolicyJDK7.zip";
  jceDownloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jce-7-download-432124.html;
  sha256JCE = "7a8d790e7bd9c2f82a83baddfae765797a4a56ea603c9150c87b7cdb7800194d";
}
