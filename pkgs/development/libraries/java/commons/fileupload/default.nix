{lib, stdenv, fetchurl}:

stdenv.mkDerivation rec {
  version = "1.5";
  pname = "commons-fileupload";

  src = fetchurl {
    url    = "mirror://apache/commons/fileupload/binaries/${pname}-${version}-bin.tar.gz";
    sha256 = "sha256-r7EGiih4qOCbjaL7Wg+plbe0m3CuFWXs/RmbfGLmj1g=";
  };
  installPhase = ''
    tar xf ${src}
    mkdir -p $out/share/java
    cp commons-fileupload-*-bin/*.jar $out/share/java/
  '';

  meta = {
    homepage    = "https://commons.apache.org/proper/commons-fileupload";
    description = "Makes it easy to add robust, high-performance, file upload capability to your servlets and web applications";
    maintainers = with lib.maintainers; [ copumpkin ];
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license     = lib.licenses.asl20;
    platforms = with lib.platforms; unix;
  };
}
