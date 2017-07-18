import ./jdk-linux-base.nix {
  productVersion = "8";
  patchVersion = "141";
  downloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html;
  sha256_i686 = "0jq8zq7hgjqbza1wmc1s8r4iz1r1s631snacn29wdsb5i2yg4qk5";
  sha256_x86_64 = "0kxs765dra47cw39xmifmxrib49j1lfya5cc3kldfv7azcc54784";
  jceName = "jce_policy-8.zip";
  jceDownloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html;
  sha256JCE = "0n8b6b8qmwb14lllk2lk1q1ahd3za9fnjigz5xn65mpg48whl0pk";
}
