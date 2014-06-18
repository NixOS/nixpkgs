{stdenv, fetchurl, libuuid}:

stdenv.mkDerivation rec {
  name = "zeromq-4.0.4";

  src = fetchurl {
    url = "http://download.zeromq.org/${name}.tar.gz";
    sha256 = "16fkax2f6h2h4wm7jrv95m6vwffd4vb1wrm1smyy4csgx531vxqy";
  };

  buildInputs = [ libuuid ];

  meta = {
    branch = "4";
    homepage = "http://www.zeromq.org";
    description = "The Intelligent Transport Layer";
  };
}
