{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "2.8.0";
  pname = "commons-io";

  src = fetchurl {
    url    = "mirror://apache/commons/io/binaries/${pname}-${version}-bin.tar.gz";
    sha256 = "02c54cjf3sdwbc9rcgg3xkx1f3yk8p5iv3iwvq78f5vfxsj53lkk";
  };

  installPhase = ''
    tar xf ${src}
    mkdir -p $out/share/java
    cp *.jar $out/share/java/
  '';

  meta = {
    homepage    = "http://commons.apache.org/proper/commons-io";
    description = "A library of utilities to assist with developing IO functionality";
    maintainers = with lib.maintainers; [ copumpkin ];
    license     = lib.licenses.asl20;
    platforms = with lib.platforms; unix;
  };
}
