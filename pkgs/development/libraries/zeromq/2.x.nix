{stdenv, fetchurl, libuuid}:

stdenv.mkDerivation rec {
  name = "zeromq-2.1.10";

  src = fetchurl {
    url = "http://download.zeromq.org/${name}.tar.gz";
    sha256 = "0yabbbgx9ajpq0hjzqjm6rmj7pkcj95d5zn7d59b4wmm6kipwwn6";
  };

  buildInputs = [ libuuid ];

  meta = {
    homepage = "http://www.zeromq.org";
    description = "The Intelligent Transport Layer";
  };
}
