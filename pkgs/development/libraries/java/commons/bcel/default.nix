{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  version = "6.8.2";
  pname = "commons-bcel";

  src = fetchurl {
    url = "mirror://apache/commons/bcel/binaries/bcel-${version}-bin.tar.gz";
    hash = "sha256-VRCRxy+P3uPW9gWy9xHfJ35muhWCHtXNimRmTfba+04=";
  };

  installPhase = ''
    tar xf ${src}
    mkdir -p $out/share/java
    cp bcel-${version}.jar $out/share/java/
  '';

  meta = {
    homepage = "https://commons.apache.org/proper/commons-bcel/";
    description = "Gives users a convenient way to analyze, create, and manipulate (binary) Java class files";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    maintainers = with lib.maintainers; [ copumpkin ];
    license = lib.licenses.asl20;
    platforms = with lib.platforms; unix;
  };
}
