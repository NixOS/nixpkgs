{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "1.20";
  pname = "commons-compress";

  src = fetchurl {
    url    = "mirror://apache/commons/compress/binaries/${pname}-${version}-bin.tar.gz";
    sha256 = "0zx1sc0rw3vzjan69vxr2qw82y9b0hqdzp4plcahc3c1y0vkz3fg";
  };

  installPhase = ''
    tar xf ${src}
    mkdir -p $out/share/java
    cp *.jar $out/share/java/
  '';

  meta = {
    homepage    = "http://commons.apache.org/proper/commons-compress";
    description = "Allows manipulation of ar, cpio, Unix dump, tar, zip, gzip, XZ, Pack200, bzip2, 7z, arj, lzma, snappy, DEFLATE and Z files";
    maintainers = with stdenv.lib.maintainers; [ copumpkin ];
    license     = stdenv.lib.licenses.asl20;
    platforms = with stdenv.lib.platforms; unix;
  };
}
