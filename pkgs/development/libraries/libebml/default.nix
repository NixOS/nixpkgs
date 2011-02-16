{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libebml-1.0.0";

  src = fetchurl {
    url = "http://dl.matroska.org/downloads/libebml/${name}.tar.bz2";
    sha256 = "0y5ip30nr96wjlh1pzw35ia1axyib158dhz8r5dxzmbcfgn0sj3j";
  };

  configurePhase = "cd make/linux";
  makeFlags = "prefix=$(out)";

  meta = {
    description = "Extensible Binary Meta Language library";
    homepage = http://dl.matroska.org/downloads/libebml/;
  };
}

