import ./jdk-linux-base.nix {
  productVersion = "8";
  patchVersion = "151";
  downloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html;
  sha256.i686-linux = "0w1snn9hxwvdnk77frhdzbsm6v30v99dy5zmpy8ij7yxd57z6ql0";
  sha256.x86_64-linux = "0zq2dxbxmshz080yskhc8y2wbqi0y0kl9girxjbb4rwk837010n7";
  sha256.armv7l-linux = "0fdkvg1al7g9lqbq10rlw400aqr0xxi2a802319sw5n0zipkrjic";
  sha256.aarch64-linux = "1xva22cjjpwa95h7x3xzyymn1bgxp1q67j5j304kn6cqah4k31j1";
  jceName = "jce_policy-8.zip";
  jceDownloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html;
  sha256JCE = "0n8b6b8qmwb14lllk2lk1q1ahd3za9fnjigz5xn65mpg48whl0pk";
}
