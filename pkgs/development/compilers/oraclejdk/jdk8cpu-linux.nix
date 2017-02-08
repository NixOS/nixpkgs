import ./jdk-linux-base.nix {
  productVersion = "8";
  patchVersion = "121";
  downloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html;
  sha256_i686 = "0k1xyg000qmd96c2r2m8l84ygn6dmjf1ih5yjzq1zry5d0aczmpp";
  sha256_x86_64 = "1g0hh9ccmsrdfa9493k31v2vd6yiymwd1nclgjh29wxfy41h5qwp";
  jceName = "jce_policy-8.zip";
  jceDownloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html;
  sha256JCE = "0n8b6b8qmwb14lllk2lk1q1ahd3za9fnjigz5xn65mpg48whl0pk";
}
