{ stdenv
, skarnetConfCompile
, fetchurl
}:

let

  version = "1.6.0.0";

in stdenv.mkDerivation rec {

  name = "skalibs-${version}";

  src = fetchurl {
    url = "http://skarnet.org/software/skalibs/${name}.tar.gz";
    sha256 = "0jz3farll9n5jvz3g6wri99s6njkgmnf0r9jqjlg03f20dzv8c8w";
  };

  sourceRoot = "prog/${name}";

  # See http://skarnet.org/cgi-bin/archive.cgi?1:mss:75:201405:pkmodhckjklemogbplje
  patches = [ ./getpeereid.patch ];

  buildInputs = [ skarnetConfCompile ];

  preInstall = ''
    mkdir -p "$out/etc"
  '';

  meta = {
    homepage = http://skarnet.org/software/skalibs/;
    description = "A set of general-purpose C programming libraries";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.isc;
  };

}
