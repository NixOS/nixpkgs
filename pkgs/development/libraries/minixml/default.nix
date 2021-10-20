{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "mxml";
  version = "3.2";

  src = fetchFromGitHub {
    owner = "michaelrsweet";
    repo = "mxml";
    rev = "v${version}";
    sha256 = "0zvib87rgsib0w9xp6bks5slq5ma1qbgyyyvr23cv7zkbgw3xgil";
  };

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A small XML library";
    homepage = "https://www.msweet.org/mxml/";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = [ maintainers.goibhniu ];
  };
}
