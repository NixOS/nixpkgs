{stdenv, fetchurl, libuuid}:

stdenv.mkDerivation rec {
  name = "zeromq-3.2.4";

  src = fetchurl {
    url = "http://download.zeromq.org/${name}.tar.gz";
    sha256 = "0n9gfhwgkwq08kvvgk5zxjga08v628ij5chddk5w4ravr10s35nz";
  };

  buildInputs = [ libuuid ];

  meta = {
    branch = "3";
    homepage = "http://www.zeromq.org";
    description = "The Intelligent Transport Layer";
  };
}
