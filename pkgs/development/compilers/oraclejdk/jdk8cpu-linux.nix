import ./jdk-linux-base.nix {
  productVersion = "8";
  patchVersion = "111";
  downloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html;
  sha256_i686 = "07wyyds52c3fp4ha1fnzp6mbxwq0rs3vx59167b57gkggg7qz3ls";
  sha256_x86_64 = "0x4937c3307v78wx1jf227b89cf5lsd5yarmbjrxs4pq6lidlzhq";
  jceName = "jce_policy-8.zip";
  jceDownloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html;
  sha256JCE = "0n8b6b8qmwb14lllk2lk1q1ahd3za9fnjigz5xn65mpg48whl0pk";
}
