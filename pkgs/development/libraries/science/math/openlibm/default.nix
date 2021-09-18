{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "openlibm";
  version = "0.8.0";
  src = fetchurl {
    url = "https://github.com/JuliaLang/openlibm/archive/v${version}.tar.gz";
    sha256 = "sha256-A2IHaN9MpSamPdZ1xt6VpcnRZ/9ZVVzlemHGv0nkAO4=";
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
