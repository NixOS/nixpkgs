import ./jdk-linux-base.nix {
  productVersion = "8";
  patchVersion = "152";
  downloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html;
  sha256_i686 = "0gjc7kcfx40f43z1w1qsn1fqxdz8d46wml2g11qgm55ishhv2q7w";
  sha256_x86_64 = "1gv1348hrgna9l3sssv3g9jzs37y1lkx05xq83chav9z1hs3p2r1";
  sha256_armv7l = "10r3nyssx8piyjaspravwgj2bnq4537041pn0lz4fk5b3473kgfb";
  sha256_aarch64 = "13qpxa8nxsnikmm7h6ysnsdqg5vl8j7hzfa8kgh20z8a17fhj9kk";
  jceName = "jce_policy-8.zip";
  jceDownloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html;
  sha256JCE = "0n8b6b8qmwb14lllk2lk1q1ahd3za9fnjigz5xn65mpg48whl0pk";
}
