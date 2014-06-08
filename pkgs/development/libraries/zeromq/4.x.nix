{stdenv, fetchurl, libuuid}:

stdenv.mkDerivation rec {
  name = "zeromq-4.0.4";

  src = fetchurl {
    url = "http://download.zeromq.org/${name}.tar.gz";
    sha256 = "1ef71d46e94f33e27dd5a1661ed626cd39be4d2d6967792a275040e34457d399";
  };

  buildInputs = [ libuuid ];

  meta = {
    branch = "4";
    homepage = "http://www.zeromq.org";
    description = "The Intelligent Transport Layer";
  };
}
