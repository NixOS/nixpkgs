{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "1.17";
  name    = "commons-compress-${version}";

  src = fetchurl {
    url    = "mirror://apache/commons/compress/binaries/${name}-bin.tar.gz";
    sha256 = "1ydm6mhy0kja47mns674iyrhz5mqlhhnh2l8rglzxnq5iawpi2m0";
  };

  installPhase = ''
    tar xf ${src}
    mkdir -p $out/share/java
    cp *.jar $out/share/java/
  '';

  meta = {
    homepage    = http://commons.apache.org/proper/commons-compress;
    description = "Allows manipulation of ar, cpio, Unix dump, tar, zip, gzip, XZ, Pack200, bzip2, 7z, arj, lzma, snappy, DEFLATE and Z files";
    maintainers = with stdenv.lib.maintainers; [ copumpkin ];
    license     = stdenv.lib.licenses.asl20;
    platforms = with stdenv.lib.platforms; unix;
  };
}
