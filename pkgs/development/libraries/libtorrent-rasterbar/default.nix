{ stdenv, fetchurl, boost, openssl, pkgconfig, zlib }:

stdenv.mkDerivation rec {
  name = "libtorrent-rasterbar-${version}";
  version = "0.15.8";
  
  src = fetchurl {
    url = "http://libtorrent.googlecode.com/files/${name}.tar.gz";
    sha256 = "0767i20igrfadscw3vdyadd4qidybwx9h898rkaq95zlwhaygpzm";
  };

  buildInputs = [ boost pkgconfig openssl zlib ];

  configureFlags = [ "--with-boost=${boost}/include/boost" "--with-boost-libdir=${boost}/lib" ];
  
  meta = with stdenv.lib; {
    homepage = http://www.rasterbar.com/products/libtorrent/;
    description = "A C++ BitTorrent implementation focusing on efficiency and scalability";
    license = licenses.bsd3;
    maintainers = [ maintainers.phreedom ];
  };
}
