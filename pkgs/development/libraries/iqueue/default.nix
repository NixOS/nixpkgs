{ lib, stdenv, fetchurl, pkg-config, libbsd, microsoft_gsl }:

stdenv.mkDerivation rec {
  pname = "iqueue";
  version = "0.1.0";
  src = fetchurl {
    url = "https://github.com/twosigma/iqueue/releases/download/v${version}/iqueue-${version}.tar.gz";
    sha256 = "0049fnr02k15gr21adav33swrwxrpbananilnrp63vp5zs5v9m4x";
  };

  doCheck = true;
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libbsd microsoft_gsl ];

  meta = with lib; {
    homepage = "https://github.com/twosigma/iqueue";
    description = "Indexed queue";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.catern ];
  };
}
