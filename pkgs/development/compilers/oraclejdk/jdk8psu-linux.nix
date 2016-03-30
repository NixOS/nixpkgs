import ./jdk-linux-base.nix {
  productVersion = "8";
  patchVersion = "77";
  downloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html;
  sha256_i686 = "14hyniai5l9qpg0pbnxa4rhyhk90qgihszfkn8h3vziqhmvrp27j";
  sha256_x86_64 = "0hyzvvj4bf0r4jda8fv3k06d9bf37nji37qbq067mcjp5abc0zd4";
  jceName = "jce_policy-8.zip";
  jceDownloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html;
  sha256JCE = "0n8b6b8qmwb14lllk2lk1q1ahd3za9fnjigz5xn65mpg48whl0pk";
}
