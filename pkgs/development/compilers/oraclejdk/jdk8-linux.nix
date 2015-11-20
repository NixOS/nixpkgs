import ./jdk-linux-base.nix {
  productVersion = "8";
  patchVersion = "65";
  downloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html;
  sha256_i686 = "1shri8mw648piivyparbpzskiq4i0z6kain9kr7ylav5mv7h66fg";
  sha256_x86_64 = "1rr6g2sb0f1vyf3l9nvj49ah28bsid92z0lj9pfjlb12vjn2mnw8";
  jceName = "jce_policy-8.zip";
  jceDownloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html;
  sha256JCE = "0n8b6b8qmwb14lllk2lk1q1ahd3za9fnjigz5xn65mpg48whl0pk";
}
