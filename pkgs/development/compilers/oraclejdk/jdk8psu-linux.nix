# http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html;
# jce download url: http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html;
import ./jdk-linux-base.nix {
  productVersion = "8";
  patchVersion = "212";
  buildVersion = "10";
  sha256.i686-linux = "03dj9q0bi3ib731f4zl9hylkrgw417h6qlg2wi7nw71b0fqhijn1";
  sha256.x86_64-linux = "1yzddxzfh6h14bpzis1abp52x4jjljg8a3zyqz483q6qm05caq1i";
  sha256.armv7l-linux = "0x333alkqdx8mmiirair7g5iiwif5v9ka4j3qr0f42ilvmk8csnx";
  sha256.aarch64-linux = "0vcbdvcsl8rm47i07s93jmrrs5laibf937d8vacjqqgh9bbhsr2c";
  releaseToken = "59066701cf1a433da9770636fbc4c9aa";
  jceName = "jce_policy-8.zip";
  sha256JCE = "0n8b6b8qmwb14lllk2lk1q1ahd3za9fnjigz5xn65mpg48whl0pk";
}
