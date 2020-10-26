{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "openlibm";
  version = "0.7.2";
  src = fetchurl {
    url = "https://github.com/JuliaLang/openlibm/archive/v${version}.tar.gz";
    sha256 = "09fl7ij0p0js2sydjvmm9k4d0c83iwpb2sad9d9hin8sjdfyp4vp";
  };

  makeFlags = [ "prefix=$(out)" ];

  meta = {
    description = "High quality system independent, portable, open source libm implementation";
    homepage = "https://www.openlibm.org/";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.ttuegel ];
    platforms = stdenv.lib.platforms.all;
  };
}
