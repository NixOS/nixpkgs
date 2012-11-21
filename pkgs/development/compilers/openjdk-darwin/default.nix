{stdenv, fetchurl, ...}:

stdenv.mkDerivation {
  name = "openjdk6-b16-24_apr_2009-r1";

  src = fetchurl {
    url = http://hg.bikemonkey.org/archive/openjdk6_darwin/openjdk6-b16-24_apr_2009-r1.tar.bz2;
    sha256 = "14pbv6jjk95k7hbgiwyvjdjv8pccm7m8a130k0q7mjssf4qmpx1v";
  };

  installPhase = ''
    mkdir -p $out
    cp -vR * $out/
  '';

}
