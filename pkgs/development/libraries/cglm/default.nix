{ stdenv, fetchFromGitHub
, pkgconfig, autoconf, automake, libtool }:

stdenv.mkDerivation rec {
  version = "0.6.0";
  pname = "cglm";

  src = fetchFromGitHub {
    owner = "recp";
    repo = "cglm";
    rev = "v${version}";
    sha256 = "02z6zpdgli43y9bh9an643w5vxgn89kk2771zk5mdl6hdk45yzkq";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ autoconf automake libtool ];
  enableParallelBuilding = true;
  preConfigure = ''
    chmod +x ./autogen.sh
    ./autogen.sh
  '';

  meta = with stdenv.lib; {
    description = "Highly Optimized Graphics Math (glm) for C";
    homepage = "https://github.com/recp/cglm";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
