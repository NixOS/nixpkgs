{ stdenv, fetchurl, boost, openssl, pkgconfig, zlib, python, libiconvOrNull, geoip
# Version specific options
, version, sha256
, ... }:

stdenv.mkDerivation rec {
  name = "libtorrent-rasterbar-${version}";
  
  src = fetchurl {
    url = "mirror://sourceforge/libtorrent/${name}.tar.gz";
    inherit sha256;
  };

  buildInputs = [ boost pkgconfig openssl zlib python libiconvOrNull geoip ];

  configureFlags = [ 
    "--enable-python-binding"
    "--with-libgeoip=system"
    "--with-libiconv=yes"
    "--with-boost=${boost.dev}"
    "--with-boost-libdir=${boost.lib}/lib"
  ] ++ stdenv.lib.optional (libiconvOrNull != null) "--with-libiconv=yes";
  
  meta = with stdenv.lib; {
    homepage = http://www.rasterbar.com/products/libtorrent/;
    description = "A C++ BitTorrent implementation focusing on efficiency and scalability";
    license = licenses.bsd3;
    maintainers = [ maintainers.phreedom ];
  };
}
