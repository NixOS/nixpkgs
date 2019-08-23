{ stdenv, requireFile, unzip, xorg }:

assert stdenv.hostPlatform.system == "i686-linux";

stdenv.mkDerivation rec {
  name = "sun-java-wtk-2.5.2_01";

  src = requireFile {
    url = meta.homepage;
    name = "sun_java_wireless_toolkit-2.5.2_01-linuxi486.bin.sh";
    sha256 = "1cjb9c27847wv0hq3j645ckn4di4vsfvp29fr4zmdqsnvk4ahvj1";
  };

  builder = ./builder.sh;

  buildInputs = [ unzip ];

  libraries = [ xorg.libXpm xorg.libXt xorg.libX11 xorg.libICE xorg.libSM stdenv.cc.cc ];

  meta = {
    homepage = http://java.sun.com/products/sjwtoolkit/download.html;
    description = "Sun Java Wireless Toolkit 2.5.2_01 for CLDC";
    license = stdenv.lib.licenses.unfree;
  };
}
