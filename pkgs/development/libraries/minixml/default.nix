{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "mxml-${version}";
  version = "2.12";

  src = fetchFromGitHub {
    owner = "michaelrsweet";
    repo = "mxml";
    rev = "v${version}";
    sha256 = "1m8z503vnfpm576gjpp1h7zmx09n50if2i28v24yx80j820ip94s";
  };

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A small XML library";
    homepage = https://www.msweet.org/mxml/;
    license = licenses.lgpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
