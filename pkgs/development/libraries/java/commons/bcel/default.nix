{lib, stdenv, fetchurl}:

stdenv.mkDerivation rec {
  version = "5.2";
  pname = "commons-bcel";

  src = fetchurl {
    url    = "mirror://apache/commons/bcel/binaries/bcel-${version}.tar.gz";
    sha256 = "13ppnd6afljdjq21jpn4ik2h1yxq8k2kg21ghi0lyb1yap1rd7k6";
  };

  installPhase = ''
    tar xf ${src}
    mkdir -p $out/share/java
    cp bcel-5.2.jar $out/share/java/
  '';

  meta = {
    homepage    = "https://commons.apache.org/proper/commons-bcel/";
    description = "Gives users a convenient way to analyze, create, and manipulate (binary) Java class files";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    maintainers = with lib.maintainers; [ copumpkin ];
    license     = lib.licenses.asl20;
    platforms = with lib.platforms; unix;
  };
}
