{ stdenv, fetchurl, pkgconfig, libsigcxx }:

let version = "0.4"; in

stdenv.mkDerivation rec {
  name = "libpar2-${version}";

  src = fetchurl {
    url = "https://launchpad.net/libpar2/trunk/${version}/+download/${name}.tar.gz";
    sha256 = "1m4ncws1h03zq7zyqbaymvjzzbh1d3lc4wb1aksrdf0ync76yv9i";
  };

  buildInputs = [ pkgconfig libsigcxx ];

  patches = [ ./libpar2-0.4-external-verification.patch ];

  meta = {
    homepage = http://parchive.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2Plus;
    description = "A library for using Parchives (parity archive volume sets)";
  };
}
