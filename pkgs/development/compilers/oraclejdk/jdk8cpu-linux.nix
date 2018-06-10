import ./jdk-linux-base.nix {
  productVersion = "8";
  patchVersion = "171";
  downloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html;
  sha256.i686-linux = "0dh5r02v40pinway952fflw2r0i1xi67hmyb87c278qfp4jn929p";
  sha256.x86_64-linux = "10jr4z0bw9wcws5xgc4qkw101cadfx5bkyvcnc4l3v5axwvjipdn";
  sha256.armv7l-linux = "1bqivmp1wfnypgg5bsfzi25yzl7vd2xncfap9mi8jn63aj633dw0";
  sha256.aarch64-linux = "1016lf3g1syjsl29m58s2s2w9nkj4jkvxhqg4s35vy41cs2v77j7";
  jceName = "jce_policy-8.zip";
  jceDownloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html;
  sha256JCE = "0n8b6b8qmwb14lllk2lk1q1ahd3za9fnjigz5xn65mpg48whl0pk";
}
