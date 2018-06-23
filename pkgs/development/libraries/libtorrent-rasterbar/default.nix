{ stdenv, fetchFromGitHub, pkgconfig, automake, autoconf, zlib, boost, openssl
, libtool, python, libiconv, geoip }:

stdenv.mkDerivation rec {
  name = "libtorrent-rasterbar-${version}";
  version = "2018-06-19";

  src = fetchFromGitHub {
    owner = "arvidn";
    repo = "libtorrent";
    # Temporary fix, use release version when updated
    rev = "f5a201530280497abfc022695c04f96f09d147cf";
    sha256 = "1ga16nxq09pl668dj7p3vifw72dc6m0h5rm3sql04f33djgf6glc";
  };

  enableParallelBuilding = true;
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

  meta = with stdenv.lib; {
    homepage = "http://www.rasterbar.com/products/libtorrent";
    description = "A C++ BitTorrent implementation focusing on efficiency and scalability";
    license = licenses.bsd3;
    maintainers = [ maintainers.phreedom ];
    platforms = platforms.unix;
  };
}
