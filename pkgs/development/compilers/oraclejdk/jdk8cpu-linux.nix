import ./jdk-linux-base.nix {
  productVersion = "8";
  patchVersion = "144";
  downloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html;
  sha256_i686 = "1i5pginc65xl5vxzwid21ykakmfkqn59v3g01vpr94v28w30jk32";
  sha256_x86_64 = "1r5axvr8dg2qmr4zjanj73sk9x50m7p0w3vddz8c6ckgav7438z8";
  sha256_armv7l = "0ja97nqn4x0ji16c7r6i9nnnj3745br7qlbj97jg1s8m2wk7f9jd";
  jceName = "jce_policy-8.zip";
  jceDownloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html;
  sha256JCE = "0n8b6b8qmwb14lllk2lk1q1ahd3za9fnjigz5xn65mpg48whl0pk";
}
