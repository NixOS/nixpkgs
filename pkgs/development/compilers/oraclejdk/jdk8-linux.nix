import ./jdk-linux-base.nix {
  productVersion = "8";
  patchVersion = "40";
  downloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html;
  sha256_i686 = "1bfabnmbar0kfx3i37wnxh97j7whkib8m6wqxrb1d9zf6k13bw50";
  sha256_x86_64 = "0nfm4xqd57s8dmkgd0jsrhys8dhfw0fx5d57mq70ramq9dl2jq66";
  jceName = "jce_policy-8.zip";
  jceDownloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html;
  sha256JCE = "f3020a3922efd6626c2fff45695d527f34a8020e938a49292561f18ad1320b59";
}
