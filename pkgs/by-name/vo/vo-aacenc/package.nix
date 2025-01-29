{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "vo-aacenc";
  version = "0.1.3";

  src = fetchurl {
    url = "mirror://sourceforge/opencore-amr/fdk-aac/${pname}-${version}.tar.gz";
    sha256 = "sha256-5Rp0d6NZ8Y33xPgtGV2rThTnQUy9SM95zBlfxEaFDzY=";
  };

  meta = with lib; {
    description = "VisualOn AAC encoder library";
    homepage    = "https://sourceforge.net/projects/opencore-amr/";
    license     = licenses.asl20;
    maintainers = [ maintainers.baloo ];
    platforms   = platforms.all;
  };
}
