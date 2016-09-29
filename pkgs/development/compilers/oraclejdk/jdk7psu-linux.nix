import ./jdk-linux-base.nix {
  productVersion = "7";
  patchVersion = "80";
  downloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html;
  sha256_i686 = "1fjpm8pa74c4vgv93lnky6pd3igln56yxdn4kbhgcg12lwc17vcx";
  sha256_x86_64 = "08wn62sammvsvlqac0n8grrikl0ykh9ikqdy823i2mcnccqsgnds";
  jceName = "UnlimitedJCEPolicyJDK7.zip";
  jceDownloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jce-7-download-432124.html;
  sha256JCE = "7a8d790e7bd9c2f82a83baddfae765797a4a56ea603c9150c87b7cdb7800194d";
  broken = true;
}
