import ./jdk-linux-base.nix {
  productVersion = "8";
  patchVersion = "51";
  downloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html;
  sha256_i686 = "0awzgs090n2cj6a5mlla0pgxk0y6aslhm6024pqrnxgai1fkmm1z";
  sha256_x86_64 = "1wggrcr2gjwkv5bawgcw86h6rhyzw0jphxm1sfwcvhjirh99056p";
  jceName = "jce_policy-8.zip";
  jceDownloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html;
  sha256JCE = "0n8b6b8qmwb14lllk2lk1q1ahd3za9fnjigz5xn65mpg48whl0pk";
}
