import ./jdk-linux-base.nix {
  productVersion = "8";
  patchVersion = "92";
  downloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html;
  sha256_i686 = "095j2hh2xas05jajy4qdj9hxq3k460x4m12rcaxkaxw754imj0vj";
  sha256_x86_64 = "11wrqd3qbkhimbw9n4g9i0635pjhhnijwxyid7lvjv26kdgg58vr";
  jceName = "jce_policy-8.zip";
  jceDownloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html;
  sha256JCE = "0n8b6b8qmwb14lllk2lk1q1ahd3za9fnjigz5xn65mpg48whl0pk";
}
