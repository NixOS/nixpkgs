import ./jdk-linux-base.nix {
  productVersion = "8";
  patchVersion = "191";
  downloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html;
  sha256.i686-linux = "1dmnv3x28l0rdi92gpmcp38gpy3lf4pl441bijvjhi7j97kk60v4";
  sha256.x86_64-linux = "0r8dvb0hahfybvf9wiv7904rn22n93bfc9x6pgypynj0w83rbhjk";
  sha256.armv7l-linux = "0wgdr9ainzc2yc5qp6ncflnsdygpgrmv2af522djkc83skp5g70v";
  sha256.aarch64-linux = "1rgwf0i9ikcjqbxkvr4x94y62m1kklfdhgqscxil479d5mg6akqz";
  jceName = "jce_policy-8.zip";
  jceDownloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html;
  sha256JCE = "0n8b6b8qmwb14lllk2lk1q1ahd3za9fnjigz5xn65mpg48whl0pk";
}
