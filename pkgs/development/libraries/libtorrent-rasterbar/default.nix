{ stdenv, fetchurl, boost, openssl, pkgconfig, zlib, python, libiconvOrNull, geoip }:

stdenv.mkDerivation rec {
  name = "libtorrent-rasterbar-${version}";
  version = "0.16.13";
  
  src = fetchurl {
    url = "http://libtorrent.googlecode.com/files/${name}.tar.gz";
    sha256 = "1sr788hhip6pgfb842110nl36hqdc1vz2s9n5vzypm0jy7qklmvm";
  };

  buildInputs = [ boost pkgconfig openssl zlib python libiconvOrNull geoip ];

  configureFlags = [ 
    "--with-boost=${boost}/include/boost" 
    "--with-boost-libdir=${boost}/lib" 
    "--enable-python-binding"
    "--with-libgeoip=system"
    "--with-libiconv=yes"
 ];
  
  meta = with stdenv.lib; {
    homepage = http://www.rasterbar.com/products/libtorrent/;
    description = "A C++ BitTorrent implementation focusing on efficiency and scalability";
    license = licenses.bsd3;
    maintainers = [ maintainers.phreedom ];
  };
}
