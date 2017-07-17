import ./jdk-linux-base.nix {
  productVersion = "8";
  patchVersion = "131";
  downloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html;
  sha256_i686 = "0m3i1n1im1nlwb06wlsdajv19cd3zhrjkw8zbyjfznydn6qs4s80";
  sha256_x86_64 = "0dhj623ya01glcl3iir9ajifcrf6awhvpk936x9cxfj8zfyibck2";
  sha256_armv7l = "0ja97nqn4x0ji16c7r6i9nnnj3745br7qlbj97jg1s8m2wk7f9jd";
  jceName = "jce_policy-8.zip";
  jceDownloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html;
  sha256JCE = "0n8b6b8qmwb14lllk2lk1q1ahd3za9fnjigz5xn65mpg48whl0pk";
}
