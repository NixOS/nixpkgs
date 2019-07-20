{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "openlibm-${version}";
  version = "0.6.0";
  src = fetchurl {
    url = "https://github.com/JuliaLang/openlibm/archive/v${version}.tar.gz";
    sha256 = "0a5fpm8nra5ldhjk0cqd2rx1qh32wiarkxmcqcm5xl8z7l4kjm6l";
  };

  makeFlags = [ "prefix=$(out)" ];

  meta = {
    description = "High quality system independent, portable, open source libm implementation";
    homepage = https://www.openlibm.org/;
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.ttuegel ];
    platforms = stdenv.lib.platforms.all;
  };
}
