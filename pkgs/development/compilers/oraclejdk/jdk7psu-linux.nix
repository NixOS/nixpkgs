import ./jdk-linux-base.nix {
  productVersion = "7";
  patchVersion = "76";
  url_i686 = http://download.oracle.com/otn-pub/java/jdk/7u76-b13/jdk-7u76-linux-i586.tar.gz;
  url_x86_64 = http://download.oracle.com/otn-pub/java/jdk/7u76-b13/jdk-7u76-linux-x64.tar.gz;
  sha256_i686 = "0558p5garc4b5g7h11dkzn161kpk84az5ad1q5hhsblbx02aqff3";
  sha256_x86_64 = "130ckrv846amyfzbnnd6skljkznc457yky7d6ajaw5ndsbzg93yf";
  urlJCE = http://download.oracle.com/otn-pub/java/jce/7/UnlimitedJCEPolicyJDK7.zip;
  sha256JCE = "7a8d790e7bd9c2f82a83baddfae765797a4a56ea603c9150c87b7cdb7800194d";
}
