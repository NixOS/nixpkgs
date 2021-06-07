{lib, stdenv, fetchurl}:

stdenv.mkDerivation rec {
  version = "1.3.1";
  pname = "commons-fileupload";

  src = fetchurl {
    url    = "mirror://apache/commons/fileupload/binaries/${pname}-${version}-bin.tar.gz";
    sha256 = "1jy7w2j2ay56mpq4ij3331cf9zgpkm832ydr63svb35j0ymnky72";
  };
  installPhase = ''
    tar xf ${src}
    mkdir -p $out/share/java
    cp lib/*.jar $out/share/java/
  '';

  meta = {
    homepage    = "http://commons.apache.org/proper/commons-fileupload";
    description = "Makes it easy to add robust, high-performance, file upload capability to your servlets and web applications";
    maintainers = with lib.maintainers; [ copumpkin ];
    license     = lib.licenses.asl20;
    platforms = with lib.platforms; unix;
  };
}
