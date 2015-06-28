import ./jdk-linux-base.nix {
  productVersion = "8";
  patchVersion = "45";
  downloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html;
  sha256_i686 = "1y1zymydd1azv14r0hh12zjr8k64wa8wfdbz8sn1css84aqwl87d";
  sha256_x86_64 = "0v9ilahx03isxdzh4ryv1bqmmzppckickz22hvgzs785769cm67j";
  jceName = "jce_policy-8.zip";
  jceDownloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html;
  sha256JCE = "0n8b6b8qmwb14lllk2lk1q1ahd3za9fnjigz5xn65mpg48whl0pk";
}
