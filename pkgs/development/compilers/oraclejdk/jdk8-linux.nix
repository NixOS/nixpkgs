import ./jdk-linux-base.nix {
  productVersion = "8";
  patchVersion = "66";
  downloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html;
  sha256_i686 = "21026a8d789f479d3905a4ead0c97fd5190aa9b4d1bfc66413e9136513ca84a2";
  sha256_x86_64 = "7e95ad5fa1c75bc65d54aaac9e9986063d0a442f39a53f77909b044cef63dc0a";
  jceName = "jce_policy-8.zip";
  jceDownloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html;
  sha256JCE = "0n8b6b8qmwb14lllk2lk1q1ahd3za9fnjigz5xn65mpg48whl0pk";
}
