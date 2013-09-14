{ stdenv, fetchurl, pkgconfig, automake, autoconf, libtool, curl, leveldb,
  protobuf, boost
}:

let version = "1.0.10"; in

stdenv.mkDerivation {
  name = "libbitcoin-${version}";

  src = fetchurl {
    url = "http://libbitcoin.dyne.org/download/libbitcoin-1.0.10.tar.bz2";
    sha256 = "2b8b5e6772b0872cc186b08a3e0ebdaaf4c9f06fb7192ba9414f6e67f083c06d";
  };

  buildInputs = [ pkgconfig automake autoconf libtool curl leveldb protobuf boost ];

  preConfigure = "autoreconf -i";
  configureFlags = "--enable-leveldb";

  meta = {
    homepage = https://github.com/spesmilo/libbitcoin;
    description = "asynchronous C++ library for Bitcoin";
    license = stdenv.lib.licenses.agpl3;
    platforms = stdenv.lib.platforms.linux;
  };
}
