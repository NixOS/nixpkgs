{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "meta-build-env-0.1";
  src = fetchurl {
    url = http://www.meta-environment.org/releases/meta-build-env-0.1.tar.gz ;
    md5 = "827b54ace4e2d3c8e7605ea149b34293";
  };

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
