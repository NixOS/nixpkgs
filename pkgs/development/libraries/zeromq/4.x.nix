{stdenv, fetchurl, libuuid}:

stdenv.mkDerivation rec {
  name = "zeromq-4.0.5";

  src = fetchurl {
    url = "http://download.zeromq.org/${name}.tar.gz";
    sha256 = "0arl8fy8d03xd5h0mgda1s5bajwg8iyh1kk4hd1420rpcxgkrj9v";
  };

  buildInputs = [ libuuid ];

  meta = {
    branch = "4";
    homepage = "http://www.zeromq.org";
    description = "The Intelligent Transport Layer";
  };
}
