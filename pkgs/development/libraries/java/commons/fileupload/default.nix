{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  version = "1.3.1";
  name    = "commons-fileupload-${version}";

  src = fetchurl {
    url    = "mirror://apache/commons/fileupload/binaries/${name}-bin.tar.gz";
    sha256 = "1jy7w2j2ay56mpq4ij3331cf9zgpkm832ydr63svb35j0ymnky72";
  };
  installPhase = ''
    tar xf ${src}
    mkdir -p $out/share/java
    cp lib/*.jar $out/share/java/
  '';

  meta = {
    homepage    = http://commons.apache.org/proper/commons-fileupload;
    description = "Makes it easy to add robust, high-performance, file upload capability to your servlets and web applications";
    maintainers = with stdenv.lib.maintainers; [ copumpkin ];
    license     = stdenv.lib.licenses.asl20;
    platforms = with stdenv.lib.platforms; unix;
  };
}
