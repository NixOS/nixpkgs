{ stdenv, fetchurl, pkgconfig, libsigcxx }:

let version = "0.4"; in

stdenv.mkDerivation rec {
  pname = "libpar2";
  inherit version;

  src = fetchurl {
    url = "https://launchpad.net/libpar2/trunk/${version}/+download/${pname}-${version}.tar.gz";
    sha256 = "1m4ncws1h03zq7zyqbaymvjzzbh1d3lc4wb1aksrdf0ync76yv9i";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libsigcxx ];

  patches = [ ./libpar2-0.4-external-verification.patch ];

  CXXFLAGS = stdenv.lib.optionalString stdenv.cc.isClang "-std=c++11";

  meta = {
    homepage = http://parchive.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2Plus;
    description = "A library for using Parchives (parity archive volume sets)";
    platforms = stdenv.lib.platforms.unix;
  };
}
