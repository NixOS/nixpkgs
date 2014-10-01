{ stdenv, fetchurl, boost, openssl, pkgconfig, zlib, python, libiconvOrNull, geoip }:

stdenv.mkDerivation rec {
  name = "libtorrent-rasterbar-1.0.2";
  
  src = fetchurl {
    url = "mirror://sourceforge/libtorrent/${name}.tar.gz";
    sha256 = "1ph4cb6nrk2hiy89j3kz1wj16ph0b9yixrf4f4935rnzhha8x31w";
  };

  buildInputs = [ boost pkgconfig openssl zlib python libiconvOrNull geoip ];

  configureFlags = [ 
    "--enable-python-binding"
    "--with-libgeoip=system"
    "--with-libiconv=yes"
    "--with-boost=${boost.lib}"
 ];
  
  meta = with stdenv.lib; {
    homepage = http://www.rasterbar.com/products/libtorrent/;
    description = "A C++ BitTorrent implementation focusing on efficiency and scalability";
    license = licenses.bsd3;
    maintainers = [ maintainers.phreedom ];
  };
}
