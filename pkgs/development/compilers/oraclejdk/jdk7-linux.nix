import ./jdk-linux-base.nix {
  productVersion = "7";
  patchVersion = "75";
  url_i686 = http://download.oracle.com/otn-pub/java/jdk/7u75-b13/jdk-7u75-linux-i586.tar.gz;
  url_x86_64 = http://download.oracle.com/otn-pub/java/jdk/7u75-b13/jdk-7u75-linux-x64.tar.gz;
  sha256_i686 = "173ppi5d90hllqgys90wlv596bpj2iw8gsbsr6pk7xvd4l1wdhrw";
  sha256_x86_64 = "040n50nglr6rcli2pz5rd503c2qqdqqbqynp6hzc4kakkchmj2a6";
  urlJCE = http://download.oracle.com/otn-pub/java/jce/7/UnlimitedJCEPolicyJDK7.zip;
  sha256JCE = "7a8d790e7bd9c2f82a83baddfae765797a4a56ea603c9150c87b7cdb7800194d";
}
