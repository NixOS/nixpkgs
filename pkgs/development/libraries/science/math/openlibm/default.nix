{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "openlibm";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "JuliaLang";
    repo = "openlibm";
    rev = "v${version}";
    sha256 = "sha256-EnpwYtBpY+s5FVI2jhaFHTtAKHeaRlZVnWE/o2T1+FY=";
  };

  makeFlags = [ "prefix=$(out)" "CC=${stdenv.cc.targetPrefix}cc" ];

  meta = {
    description = "High quality system independent, portable, open source libm implementation";
    homepage = "https://openlibm.org/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ttuegel ];
    platforms = lib.platforms.all;
  };
}
