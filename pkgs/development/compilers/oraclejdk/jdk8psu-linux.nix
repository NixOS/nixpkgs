import ./jdk-linux-base.nix {
  productVersion = "8";
  patchVersion = "172";
  downloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html;
  sha256.i686-linux = "0csskx8xis0dr1948j76fgrwwsj4gzdbjqfi7if4v4j62b9i0hqa";
  sha256.x86_64-linux = "0inkx73rwv7cvn9lqcr3hmnm0sr89h1fh29yamikb4dn02a0p818";
  sha256.armv7l-linux = "1576cb0rlc42dsnmh388gy1wjas7ac6g135s8h74x8sm4b56qpln";
  sha256.aarch64-linux = "0zpkmq8zxmpifawj611fg67srki63haz02rm6xwfc5qm2lxx5g6s";
  jceName = "jce_policy-8.zip";
  jceDownloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html;
  sha256JCE = "0n8b6b8qmwb14lllk2lk1q1ahd3za9fnjigz5xn65mpg48whl0pk";
}
