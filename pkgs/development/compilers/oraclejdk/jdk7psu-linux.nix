import ./jdk-linux-base.nix {
  productVersion = "7";
  patchVersion = "76";
  downloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html;
  sha256_i686 = "0558p5garc4b5g7h11dkzn161kpk84az5ad1q5hhsblbx02aqff3";
  sha256_x86_64 = "130ckrv846amyfzbnnd6skljkznc457yky7d6ajaw5ndsbzg93yf";
  jceName = "UnlimitedJCEPolicyJDK7.zip";
  jceDownloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jce-7-download-432124.html;
  sha256JCE = "7a8d790e7bd9c2f82a83baddfae765797a4a56ea603c9150c87b7cdb7800194d";
}
