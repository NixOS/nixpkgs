{stdenv, fetchurl, libuuid}:

stdenv.mkDerivation rec {
  name = "zeromq-3.2.1-rc2";

  src = fetchurl {
    url = "http://download.zeromq.org/${name}.tar.gz";
    sha256 = "b0a70da77e39537120a1fa058c49434982741ecef5211edcd7aeab4caffb82b7";
  };

  buildInputs = [ libuuid ];

  meta = {
    homepage = "http://www.zeromq.org";
    description = "The Intelligent Transport Layer";
  };
}
