{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libebml-1.3.0";

  src = fetchurl {
    url = "http://dl.matroska.org/downloads/libebml/${name}.tar.bz2";
    sha256 = "1plnh2dv8k9s4d06c2blv2sl8bnz6d6shvj0h00al597nvb79c43";
  };

  configurePhase = "cd make/linux";
  makeFlags = "prefix=$(out)";

  meta = {
    description = "Extensible Binary Meta Language library";
    homepage = http://dl.matroska.org/downloads/libebml/;
  };
}

