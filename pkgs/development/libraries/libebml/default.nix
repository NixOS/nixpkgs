{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libebml-1.2.2";

  src = fetchurl {
    url = "http://dl.matroska.org/downloads/libebml/${name}.tar.bz2";
    sha256 = "19dp8m97xaj46iv6ahb5v0fb9sawjiy8wy1ylljc15ka8g30hss7";
  };

  configurePhase = "cd make/linux";
  makeFlags = "prefix=$(out)";

  meta = {
    description = "Extensible Binary Meta Language library";
    homepage = http://dl.matroska.org/downloads/libebml/;
  };
}

