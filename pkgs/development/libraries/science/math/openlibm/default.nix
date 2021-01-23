{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "openlibm";
  version = "0.7.3";
  src = fetchurl {
    url = "https://github.com/JuliaLang/openlibm/archive/v${version}.tar.gz";
    sha256 = "0m3khv7qidhfly634bf5w0ci5qnvndmihc4a836a0cy047pw9g6k";
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
