import ./jdk-linux-base.nix {
  productVersion = "8";
  patchVersion = "251";
  sha256.i686-linux = "0c6d25c09459e435570204f1a22a1cb765ce5d62c5bced92c9a9546b7be337f2";
  sha256.x86_64-linux = "777a8d689e863275a647ae52cb30fd90022a3af268f34fc5b9867ce32f1b374e";
  sha256.armv7l-linux = "f1b0c979e1b61ec52ebd5e1d0b754d7681d8623b09ac90c69718a553ef9b0cd1";
  sha256.aarch64-linux = "58baeaab7da97dd5a6b02ad2dcd77c14b3b6ba014029ee67dbc2bd5f0fa98d1b";
  jceName = "jce_policy-8.zip";
  sha256JCE = "0n8b6b8qmwb14lllk2lk1q1ahd3za9fnjigz5xn65mpg48whl0pk";
}
