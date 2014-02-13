{ stdenv, fetchurl, boost, openssl, pkgconfig, zlib, python, libiconvOrNull, geoip }:

stdenv.mkDerivation rec {
  name = "libtorrent-rasterbar-${version}";
  version = "0.16.14";
  
  src = fetchurl {
    url = mirror://sourceforge/libtorrent/libtorrent-rasterbar-0.16.14.tar.gz;
    sha256 = "0s4f36f28cgq55pgx4h99q18a0p566bhifxmqxjhlb63a1w20m2c";
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
