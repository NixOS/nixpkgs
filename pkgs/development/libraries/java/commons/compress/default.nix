{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "1.8.1";
  name    = "commons-compress-${version}";

  src = fetchurl {
    url    = "mirror://apache/commons/compress/binaries/${name}-bin.tar.gz";
    sha256 = "11viabgf34r3zx1avj51n00hzmx89kym3i90l6a5v5dbfh61h0lp";
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
