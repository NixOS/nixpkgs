{ stdenv, fetchurl, pkgconfig, cmake, zlib, glib }:

stdenv.mkDerivation rec {
  name = "libproxy-0.4.11";
  src = fetchurl {
    url = "http://libproxy.googlecode.com/files/${name}.tar.gz";
    sha256 = "0jw6454gxjykmbnbh544axi8hzz9gmm4jz1y5gw1hdqnakg36gyw";
  };

  outputs = [ "dev" "out" ]; # to deal with propagatedBuildInputs

  nativeBuildInputs = [ pkgconfig cmake ];
  propagatedBuildInputs = [ zlib ]
    # now some optional deps, but many more are possible
    ++ [ glib ];
}
