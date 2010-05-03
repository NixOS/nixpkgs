{ stdenv, fetchurl, pkgconfig, glib }:

stdenv.mkDerivation rec {
  name = "liblqr-1-0.4.1";
  src = fetchurl {
    url = "${meta.homepage}/local--files/en:download-page/${name}.tar.bz2";
    sha256 = "02g90wag7xi5rjlmwq8h0qs666b1i2sa90s4303hmym40il33nlz";
  };

  buildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ glib ];
  configureFlags = "--enable-install-man";

  meta = with stdenv.lib; {
    homepage = http://liblqr.wikidot.com;
    description = "Seam-carving C/C++ library called Liquid Rescaling";
    platforms = platforms.all;
    maintainers = [ maintainers.urkud ];
  };
}
