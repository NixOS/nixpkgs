{ stdenv, fetchurl, automake, autoconf, boost, openssl, lib, libtool, pkgconfig, zlib, python, libiconv, geoip
# Version specific options
, version, sha256
, ... }:

let formattedVersion = lib.replaceChars ["."] ["_"] version;

in

stdenv.mkDerivation rec {
  name = "libtorrent-rasterbar-${version}";
  
  src = fetchurl {
    url = "https://github.com/arvidn/libtorrent/archive/libtorrent-${formattedVersion}.tar.gz";
    inherit sha256;
  };

  nativeBuildInputs = [automake autoconf libtool ];

  buildInputs = [ boost pkgconfig openssl zlib python libiconv geoip ];

  preConfigure = "./autotool.sh";

  configureFlags = [ 
    "--enable-python-binding"
    "--with-libgeoip=system"
    "--with-libiconv=yes"
    "--with-boost=${boost.dev}"
    "--with-boost-libdir=${boost.out}/lib"
    "--with-libiconv=yes"
  ];

  enableParallelBuilding = true;
  
  meta = with stdenv.lib; {
    homepage = http://www.rasterbar.com/products/libtorrent/;
    description = "A C++ BitTorrent implementation focusing on efficiency and scalability";
    license = licenses.bsd3;
    maintainers = [ maintainers.phreedom ];
  };
}
