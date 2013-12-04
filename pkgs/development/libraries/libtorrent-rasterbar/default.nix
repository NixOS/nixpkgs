{ stdenv, fetchurl, boost, openssl, pkgconfig, zlib, python }:

stdenv.mkDerivation rec {
  name = "libtorrent-rasterbar-${version}";
  version = "0.16.12";
  
  src = fetchurl {
    url = "http://libtorrent.googlecode.com/files/${name}.tar.gz";
    sha256 = "0s2nxhz4d93xcl6hchmfgi8hq7aw8mrkgixh5an7fbk4shswpcg8";
  };

  buildInputs = [ boost pkgconfig openssl zlib python ];

  configureFlags = [ 
    "--with-boost=${boost}/include/boost" 
    "--with-boost-libdir=${boost}/lib" 
    "--enable-python-binding"
 ];
  
  meta = with stdenv.lib; {
    homepage = http://www.rasterbar.com/products/libtorrent/;
    description = "A C++ BitTorrent implementation focusing on efficiency and scalability";
    license = licenses.bsd3;
    maintainers = [ maintainers.phreedom ];
  };
}
