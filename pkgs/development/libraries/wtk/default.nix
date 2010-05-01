{ stdenv, fetchurl, unzip, xlibs }:

assert stdenv.system == "i686-linux";

stdenv.mkDerivation rec {
  name = "sun-java-wtk-2.5.2_01";

  src = fetchurl {
    url = meta.homepage;
    name = "sun_java_wireless_toolkit-2.5.2_01-linuxi486.bin.sh";
    restricted = true;
    md5 = "6b70b6e6d426eac121db8a087991589f";
  };

  builder = ./builder.sh;

  buildInputs = [ unzip ];

  libraries = [ xlibs.libXpm xlibs.libXt xlibs.libX11 xlibs.libICE xlibs.libSM stdenv.gcc.gcc ];

  meta = {
    homepage = http://java.sun.com/products/sjwtoolkit/download.html;
    description = "Sun Java Wireless Toolkit 2.5.2_01 for CLDC";
    license = "unfree";
  };
}
