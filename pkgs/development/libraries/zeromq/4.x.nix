{ stdenv, fetchurl, libuuid }:

stdenv.mkDerivation rec {
  name = "zeromq-4.0.6";

  src = fetchurl {
    url = "http://download.zeromq.org/${name}.tar.gz";
    sha256 = "0arl8fy8d03xd5h0mgda1s5bajwg8iyh1kk4hd1420rpcxgkrj91";
  };

  buildInputs = [ libuuid ];

  meta = with stdenv.lib; {
    branch = "4";
    homepage = "http://www.zeromq.org";
    description = "The Intelligent Transport Layer";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
