# http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html;
# jce download url: http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html;
import ./jdk-linux-base.nix {
  productVersion = "8";
  patchVersion = "201";
  buildVersion = "09";
  sha256.i686-linux = "1f9n93zmkggchaxkchp4bqasvxznn96zjci34f52h7v392jkzqac";
  sha256.x86_64-linux = "0w730v2q0iaxf2lprabwmy7129byrs0hhdbwas575p1xmk00qw6b";
  sha256.armv7l-linux = "0y6bvq93lsf21v6ca536dpfhkk5ljsj7c6di0qzkban37bivj0si";
  sha256.aarch64-linux = "1bybysgg9llqzllsmdszmmb73v5az2l1shxn6lxwv3wwiazpf47q";
  releaseToken = "42970487e3af4f5aa5bca3f542482c60";
  jceName = "jce_policy-8.zip";
  sha256JCE = "0n8b6b8qmwb14lllk2lk1q1ahd3za9fnjigz5xn65mpg48whl0pk";
}
