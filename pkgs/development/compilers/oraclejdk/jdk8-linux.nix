import ./jdk-linux-base.nix {
  productVersion = "8";
  patchVersion = "91";
  downloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html;
  sha256_i686 = "0lndni81vfpz2l6zb8zsshaavk0483q5jc8yzj4fdjv6wnshbkay";
  sha256_x86_64 = "0lkm3fz1vdi69f34sysavvh3abx603j1frc9hxvr08pwvmm536vg";
  jceName = "jce_policy-8.zip";
  jceDownloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html;
  sha256JCE = "0n8b6b8qmwb14lllk2lk1q1ahd3za9fnjigz5xn65mpg48whl0pk";
}
