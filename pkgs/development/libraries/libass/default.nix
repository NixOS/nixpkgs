{ stdenv, fetchurl, freetype, fontconfig, pkgconfig, enca ? null }:

stdenv.mkDerivation rec {
  name = "libass-0.9.11";

  src = fetchurl {
    url = "http://libass.googlecode.com/files/${name}.tar.bz2";
    sha256 = "0p3li523s8n85kfh5xdbbfffr17z8xdh2qcgvdg7ki1myv6agl7z";
  };

  buildInputs = [ freetype fontconfig enca pkgconfig ];

  meta = {
    homepage = http://code.google.com/p/libass/;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
