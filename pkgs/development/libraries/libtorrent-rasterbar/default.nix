{ stdenv, fetchurl, boost, openssl, pkgconfig, zlib, python }:

stdenv.mkDerivation rec {
  name = "libtorrent-rasterbar-${version}";
  version = "0.16.8";
  
  src = fetchurl {
    url = "http://libtorrent.googlecode.com/files/${name}.tar.gz";
    sha256 = "01jxhyndqkc0qag22s5w0vs63hlp4rr4bca8k7fj37gky7w119c0";
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
