{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "tidyp-1.04";

  src = fetchurl {
    url = "https://github.com/downloads/petdance/tidyp/${name}.tar.gz";
    sha256 = "0f5ky0ih4vap9c6j312jn73vn8m2bj69pl2yd3a5nmv35k9zmc10";
  };

  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    description = "A program that can validate your HTML, as well as modify it to be more clean and standard";
    homepage = http://tidyp.com/;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
