import ./jdk-linux-base.nix {
  productVersion = "7";
  patchVersion = "55";
  downloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html;
  sha256_i686 = "0y0v5ilbkdmf14jrvwa23x91rfdw90jji4y7hq0l494iy4wjnyc1";
  sha256_x86_64 = "15sncxhjasv5i6p7hfrr92xq5ph9g6g12i4m52vp45l031bw5y46";
  jceName = "UnlimitedJCEPolicyJDK7.zip";
  jceDownloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jce-7-download-432124.html;
  sha256JCE = "7a8d790e7bd9c2f82a83baddfae765797a4a56ea603c9150c87b7cdb7800194d";
}
