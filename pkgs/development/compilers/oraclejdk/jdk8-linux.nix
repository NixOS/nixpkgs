import ./jdk-linux-base.nix {
  productVersion = "8";
  patchVersion = "261";
  sha256.i686-linux = "1bl12hd5i53m8d4j8rwkk3bavmzw0ndr88ch5lf5syi7vs5pfjpm";
  sha256.x86_64-linux = "0d7a92csz8ws5h0pzqmrxq3sz286s57vw0dqq3ciwsqz14df012s";
  sha256.armv7l-linux = "13dih7zyfgj90bkhnfxhpm88d9kqqrj6w5rzpidmxrjwrsnlndp9";
  sha256.aarch64-linux = "0zzhs4pcnjss2561b8zrrnacpkb8p49ca0lpdw7hzgsjjj1y146n";
  jceName = "jce_policy-8.zip";
  sha256JCE = "0n8b6b8qmwb14lllk2lk1q1ahd3za9fnjigz5xn65mpg48whl0pk";
}
