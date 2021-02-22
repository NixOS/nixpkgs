{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "openlibm";
  version = "0.7.4";
  src = fetchurl {
    url = "https://github.com/JuliaLang/openlibm/archive/v${version}.tar.gz";
    sha256 = "sha256-61hSBNbJlWkeVUXqT/y4h8FZvwXMXuG7+Spvzd4vzK4=";
  };

  makeFlags = [ "prefix=$(out)" ];

  meta = {
    description = "High quality system independent, portable, open source libm implementation";
    homepage = "https://openlibm.org/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ttuegel ];
    platforms = lib.platforms.all;
  };
}
