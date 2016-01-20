import ./jdk-linux-base.nix {
  productVersion = "8";
  patchVersion = "72";
  downloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html;
  sha256_i686 = "023rnlm5v7d9w4d7bgcac8j0r1vqkbv6fl20k8354pzpdjg6liaq";
  sha256_x86_64 = "167ca39a6y0n8l87kdm5nv2hrp0wf6g4mw1rbychjc04f5igkrs6";
  jceName = "jce_policy-8.zip";
  jceDownloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html;
  sha256JCE = "0n8b6b8qmwb14lllk2lk1q1ahd3za9fnjigz5xn65mpg48whl0pk";
}
