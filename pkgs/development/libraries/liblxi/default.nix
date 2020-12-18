{ stdenv, fetchFromGitHub
, automake, autoconf, libtool, pkgconfig
, avahi, libxml2
}:

stdenv.mkDerivation {
  name = "liblxi-1.13";

  src = fetchFromGitHub {
    owner = "lxi-tools";
    repo = "liblxi";
    rev = "v1.13";
    sha256 = "129m0k2wrlgs25qkskynljddqspasla1x8iq51vmg38nhnilpqf6";
  };

  preConfigure = "./autogen.sh";

  buildInputs = [ avahi libxml2 ];
  nativeBuildInputs = [ automake autoconf libtool pkgconfig ];

  meta = with stdenv.lib; {
    description = "Library for communicating with LXI compatible instruments";
    longDescription = ''
      liblxi is an open source software library which offers a simple
      API for communicating with LXI compatible instruments.
      The API allows applications to easily discover instruments
      on networks and communicate SCPI commands.
    '';
    homepage = "https://lxi-tools.github.io/";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.vq ];
  };
}
