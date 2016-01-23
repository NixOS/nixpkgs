import ./jdk-linux-base.nix {
  productVersion = "8";
  patchVersion = "71";
  downloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html;
  sha256_i686 = "11wcizv4gvlffzn2wj34ffwrq21xwh4ikg2vjv63avdfp2hazjqv";
  sha256_x86_64 = "18jqdrlbv4sdds2hlmp437waq7r9b33f7hdp8kb6l7pkrizr9nwv";
  jceName = "jce_policy-8.zip";
  jceDownloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html;
  sha256JCE = "0n8b6b8qmwb14lllk2lk1q1ahd3za9fnjigz5xn65mpg48whl0pk";
}
