{
  lib,
  stdenv,
  requireFile,
  unzip,
  libxt,
  libxpm,
  libx11,
  libsm,
  libice,
}:

stdenv.mkDerivation rec {
  pname = "sun-java-wtk";
  version = "2.5.2_01";

  src = requireFile {
    url = "http://java.sun.com/products/sjwtoolkit/download.html";
    name = "sun_java_wireless_toolkit-${version}-linuxi486.bin.sh";
    sha256 = "1cjb9c27847wv0hq3j645ckn4di4vsfvp29fr4zmdqsnvk4ahvj1";
  };

  builder = ./builder.sh;

  nativeBuildInputs = [ unzip ];

  libraries = [
    libxpm
    libxt
    libx11
    libice
    libsm
    stdenv.cc.cc
  ];

  meta = {
    homepage = "http://java.sun.com/products/sjwtoolkit/download.html";
    description = "Sun Java Wireless Toolkit 2.5.2_01 for CLDC";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [ "i686-linux" ];
  };
}
