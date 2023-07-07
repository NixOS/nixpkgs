{lib, stdenv, fetchurl}:

stdenv.mkDerivation rec {
  version = "6.6.1";
  pname = "commons-bcel";

  src = fetchurl {
    url    = "mirror://apache/commons/bcel/binaries/bcel-${version}-bin.tar.gz";
    sha256 = "sha256-bwbERZqnmXD2LzGilDZYsr7BPQoTeZDwDU/8/AjAdP4=";
  };

  installPhase = ''
    tar xf ${src}
    mkdir -p $out/share/java
    cp bcel-${version}.jar $out/share/java/
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
