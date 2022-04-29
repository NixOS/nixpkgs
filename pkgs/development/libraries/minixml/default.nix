{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "mxml";
  version = "3.3";

  src = fetchFromGitHub {
    owner = "michaelrsweet";
    repo = "mxml";
    rev = "v${version}";
    sha256 = "sha256-YN8g8KDk7xnDVK1io0zSLO7erxEp4VQ9heA7Lu/cUUg=";
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
