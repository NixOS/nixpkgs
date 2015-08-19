import ./jdk-linux-base.nix {
  productVersion = "7";
  patchVersion = "79";
  url_i686 = http://download.oracle.com/otn-pub/java/jdk/7u79-b15/jdk-7u79-linux-i586.tar.gz;
  url_x86_64 = http://download.oracle.com/otn-pub/java/jdk/7u79-b15/jdk-7u79-linux-x64.tar.gz;
  sha256_i686 = "1hv9bmj08y8gavhhkip5w5dg96b1dy4sc2cidpjcbwpb2mzh5lhs";
  sha256_x86_64 = "140xl5kfdrlmh8wh2x3j23x53dbil8qxsvc7gf3138mz4805vmr9";
  urlJCE = http://download.oracle.com/otn-pub/java/jce/7/UnlimitedJCEPolicyJDK7.zip;
  sha256JCE = "7a8d790e7bd9c2f82a83baddfae765797a4a56ea603c9150c87b7cdb7800194d";
}
