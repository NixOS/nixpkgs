# http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html;
# jce download url: http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html;
import ./jdk-linux-base.nix {
  productVersion = "8";
  patchVersion = "202";
  buildVersion = "09";
  sha256.i686-linux = "19np392dwdqdq39lmm10607w2h042lrm5953fnsfh1bb9jli1pgj";
  sha256.x86_64-linux = "1q4l8pymjvsvxfwaw0rdcnhryh1la2bvg5f4d4my41ka390k4p4s";
  sha256.armv7l-linux = "06aljl7dqmmhmp7xswgvkcgh9mam71wnqydg9yb3hkcc443cm581";
  sha256.aarch64-linux = "12v9ndv7a2c9zqq6ai2vsgwad0lzmf4c6jxy4p9miapmhjzx5vii";
  releaseToken = "42970487e3af4f5aa5bca3f542482c60";
  jceName = "jce_policy-8.zip";
  sha256JCE = "0n8b6b8qmwb14lllk2lk1q1ahd3za9fnjigz5xn65mpg48whl0pk";
}
