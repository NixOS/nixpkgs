{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gtk2,
  libxml2,
}:

stdenv.mkDerivation rec {
  pname = "verbiste";

  version = "0.1.48";

  src = fetchurl {
    url = "https://perso.b2b2c.ca/~sarrazip/dev/verbiste-${version}.tar.gz";
    hash = "sha256-qp0OFpH4DInWjzraDI6+CeKh85JkbwVYHlJruIrGnBM=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    gtk2
    libxml2
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "http://sarrazip.com/dev/verbiste.html";
    description = "French and Italian verb conjugator";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ orivej ];
  };
}
