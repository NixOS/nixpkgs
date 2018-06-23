{ stdenv, fetchurl, fetchpatch, automake, autoconf, boost, openssl, lib, libtool, pkgconfig, zlib, python, libiconv, geoip, ... }:

stdenv.mkDerivation rec {
  name = "libtorrent-rasterbar-${version}";
  version = "1.1.7";

  src =
    let formattedVersion = lib.replaceChars ["."] ["_"] version;
    in fetchurl {
      url = "https://github.com/arvidn/libtorrent/archive/libtorrent-${formattedVersion}.tar.gz";
      sha256 = "0vbw7wcw8x9787rq5fwaibpvvspm3237l8ahbf20gjpzxhn4yfwc";
    };

patches = [
  (fetchpatch {
    url = "https://github.com/arvidn/libtorrent/commit/64d6b4900448097b0157abb328621dd211e2947d.patch";
    sha256 = "0d4h0g129rsgm8xikybxypgv6nnya7ap7kskl7q78p4h6y2a0fhc";
  })
];

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

  doCheck = false; # fails to link

  meta = with stdenv.lib; {
    homepage = http://www.rasterbar.com/products/libtorrent/;
    description = "A C++ BitTorrent implementation focusing on efficiency and scalability";
    license = licenses.bsd3;
    maintainers = [ maintainers.phreedom ];
    platforms = platforms.unix;
  };
}
