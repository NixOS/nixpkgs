{ stdenv, fetchurl, automake, autoconf, boost, openssl, lib, libtool, pkgconfig, zlib, python, libiconv, geoip, ... }:

stdenv.mkDerivation rec {
  name = "libtorrent-rasterbar-${version}";
  version = "1.1.7";

  src =
    let formattedVersion = lib.replaceChars ["."] ["_"] version;
    in fetchurl {
      url = "https://github.com/arvidn/libtorrent/archive/libtorrent-${formattedVersion}.tar.gz";
      sha256 = "0vbw7wcw8x9787rq5fwaibpvvspm3237l8ahbf20gjpzxhn4yfwc";
    };

  nativeBuildInputs = [ automake autoconf libtool pkgconfig ];
  buildInputs = [ boost openssl zlib python libiconv geoip ];

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
    platforms = platforms.unix;
  };
}
