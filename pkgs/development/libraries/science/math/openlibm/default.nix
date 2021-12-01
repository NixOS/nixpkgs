{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "openlibm";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "JuliaLang";
    repo = "openlibm";
    rev = "v${version}";
    sha256 = "sha256-dEM10picZXiPokzSHCfxhS7fwZ0sMjil4bni+PHBCeI=";
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
