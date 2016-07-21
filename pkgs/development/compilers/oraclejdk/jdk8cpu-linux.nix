import ./jdk-linux-base.nix {
  productVersion = "8";
  patchVersion = "101";
  downloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html;
  sha256_i686 = "0p9nvaifb1mn7scmprbcyv9a4lyqy8i0mf7rsb59cli30vpi44mi";
  sha256_x86_64 = "0a0kb3c7xfh81vx5sicw2frgxq0gyv5qp0d725rviwldlcxk4zs6";
  jceName = "jce_policy-8.zip";
  jceDownloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html;
  sha256JCE = "0n8b6b8qmwb14lllk2lk1q1ahd3za9fnjigz5xn65mpg48whl0pk";
}
