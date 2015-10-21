import ./jdk-linux-base.nix {
  productVersion = "8";
  patchVersion = "66";
  downloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html;
  sha256_i686 = "18l4r89na4z92djcdgyinjlhl6fmgz4x1sm40lwrsiwzg26nl0i1";
  sha256_x86_64 = "02nwcgplq14vj1vkz99r5x20lg86hscrxb5aaifwcny7l5gsv5by";
  jceName = "jce_policy-8.zip";
  jceDownloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html;
  sha256JCE = "0n8b6b8qmwb14lllk2lk1q1ahd3za9fnjigz5xn65mpg48whl0pk";
}
