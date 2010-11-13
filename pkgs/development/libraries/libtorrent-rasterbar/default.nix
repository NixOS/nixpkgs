{ stdenv, fetchurl, boost, openssl, pkgconfig, zlib }:

stdenv.mkDerivation rec {
  name = "libtorrent-rasterbar-${version}";
  version = "0.15.4";
  
  src = fetchurl {
    url = "http://libtorrent.googlecode.com/files/${name}.tar.gz";
    sha256 = "1pjdn0as4h71bhm0fbjqsh1y10fbifn2hfrkhkgdsdqhz7vdbfwy";
  };

  buildInputs = [ boost pkgconfig openssl zlib ];

  configureFlags = [ "--with-boost=${boost}/include/boost" "--with-boost-libdir=${boost}/lib" ];
  
  meta = with stdenv.lib; {
    homepage = http://www.rasterbar.com/products/libtorrent/;
    description = "A C++ BitTorrent implementation focusing on efficiency and scalability";
    license = licenses.bsd;
    maintainers = [ maintainers.phreedom ];
  };
}
