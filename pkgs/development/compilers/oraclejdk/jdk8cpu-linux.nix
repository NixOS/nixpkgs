# http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html;
# jce download url: http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html;
import ./jdk-linux-base.nix {
  productVersion = "8";
  patchVersion = "211";
  buildVersion = "12";
  sha256.i686-linux = "0mdrljs0rw9s4pvaa3sn791nqgdrp8749z3qn80y7hhad74kvsnp";
  sha256.x86_64-linux = "13b6qk4sn8jdhxa22na9d2aazm4yjh6yxrlxr189gxy3619y9dy0";
  sha256.armv7l-linux = "1ij1x925k7lyp5f98gy8r0xfr41qhczf2rb74plwwmrccc1k00p5";
  sha256.aarch64-linux = "041r615qj9qy34a9gxm8968qlmf060ba2as5w97v86mbik4rca05";
  releaseToken = "478a62b7d4e34b78b671c754eaaf38ab";
  jceName = "jce_policy-8.zip";
  sha256JCE = "0n8b6b8qmwb14lllk2lk1q1ahd3za9fnjigz5xn65mpg48whl0pk";
}
