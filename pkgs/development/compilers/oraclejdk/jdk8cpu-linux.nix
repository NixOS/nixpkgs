import ./jdk-linux-base.nix {
  productVersion = "8";
  patchVersion = "161";
  downloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html;
  sha256_i686 = "1p6p93msn3bsg9775rq171kd4160w4w8z57p0qpjdjycfix62sfg";
  sha256_x86_64 = "07h2wah80qr78y0f821z12lbdmsv90xbckdn3glnj2riwfh5dg3d";
  sha256_armv7l = "0mngw2lnhx3hzgp444advybhjn5hjk3mi14y72km4kp03gh82a7x";
  jceName = "jce_policy-8.zip";
  jceDownloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html;
  sha256JCE = "0n8b6b8qmwb14lllk2lk1q1ahd3za9fnjigz5xn65mpg48whl0pk";
}
