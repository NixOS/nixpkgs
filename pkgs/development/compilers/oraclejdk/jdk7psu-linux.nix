import ./jdk-linux-base.nix {
  productVersion = "7";
  patchVersion = "80";
  url_i686 = http://download.oracle.com/otn-pub/java/jdk/7u80-b15/jdk-7u80-linux-i586.tar.gz;
  url_x86_64 = http://download.oracle.com/otn-pub/java/jdk/7u80-b15/jdk-7u80-linux-x64.tar.gz;
  sha256_i686 = "1fjpm8pa74c4vgv93lnky6pd3igln56yxdn4kbhgcg12lwc17vcx";
  sha256_x86_64 = "08wn62sammvsvlqac0n8grrikl0ykh9ikqdy823i2mcnccqsgnds";
  urlJCE = http://download.oracle.com/otn-pub/java/jce/7/UnlimitedJCEPolicyJDK7.zip;
  sha256JCE = "7a8d790e7bd9c2f82a83baddfae765797a4a56ea603c9150c87b7cdb7800194d";
}
