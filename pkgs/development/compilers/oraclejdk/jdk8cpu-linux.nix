# http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html;
# jce download url: http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html;
import ./jdk-linux-base.nix {
  productVersion = "8";
  patchVersion = "201";
  buildVersion = "09";
  sha256.i686-linux = "1f9n93zmkggchaxkchp4bqasvxznn96zjci34f52h7v392jkzqac";
  sha256.x86_64-linux = "0w730v2q0iaxf2lprabwmy7129byrs0hhdbwas575p1xmk00qw6b";
  sha256.armv7l-linux = "0p82d2vah63a6r2rip9v17lbjam39kgqp0584q3cnljgr5p9gyhz";
  sha256.aarch64-linux = "1qm4b3aj5wi0hp9q6gy1da4bz5k9ky4shgiqa4zxrib4kjp9yf0k";
  releaseToken = "42970487e3af4f5aa5bca3f542482c60";
  jceName = "jce_policy-8.zip";
  sha256JCE = "0n8b6b8qmwb14lllk2lk1q1ahd3za9fnjigz5xn65mpg48whl0pk";
}
