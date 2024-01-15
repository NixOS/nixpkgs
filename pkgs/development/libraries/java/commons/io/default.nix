{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "2.11.0";
  pname = "commons-io";

  src = fetchurl {
    url    = "mirror://apache/commons/io/binaries/${pname}-${version}-bin.tar.gz";
    sha256 = "sha256-9RXVNzjEhdYCYWbB9/xW3rm+gSOuD6+jwAO9zJVt4fk=";
  };

  installPhase = ''
    tar xf ${src}
    mkdir -p $out/share/java
    cp *.jar $out/share/java/
  '';

  meta = {
    homepage    = "https://commons.apache.org/proper/commons-io";
    description = "A library of utilities to assist with developing IO functionality";
    maintainers = with lib.maintainers; [ copumpkin ];
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license     = lib.licenses.asl20;
    platforms = with lib.platforms; unix;
  };
}
