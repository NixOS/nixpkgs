import ./jdk-linux-base.nix {
  productVersion = "8";
  patchVersion = "31";
  url_i686 = http://download.oracle.com/otn-pub/java/jdk/8u31-b13/jdk-8u31-linux-i586.tar.gz;
  url_x86_64 = http://download.oracle.com/otn-pub/java/jdk/8u31-b13/jdk-8u31-linux-x64.tar.gz;
  sha256_i686 = "1sr3q9y0cd42cqpf98gsv3hvip0r1vw3d0jh6yml6krzdm96zp8s";
  sha256_x86_64 = "0dz4k3xds1ydqr77hmrjc1w0niqq3jm3h18nk3ibqr1083l1bq7g";
  urlJCE = http://download.oracle.com/otn-pub/java/jce/8/jce_policy-8.zip;
  sha256JCE = "f3020a3922efd6626c2fff45695d527f34a8020e938a49292561f18ad1320b59";
}
