{ stdenv, fetchurl, SDL2 }:

stdenv.mkDerivation rec {
  name = "SDL2_net-${version}";
  version = "2.0.1";

  src = fetchurl {
    url = "http://www.libsdl.org/projects/SDL_net/release/${name}.tar.gz";
    sha256 = "08cxc1bicmyk89kiks7izw1rlx5ng5n6xpy8fy0zxni3b9z8mkhm";
  };

  propagatedBuildInputs = [ SDL2 ];

  meta = with stdenv.lib; {
    description = "SDL multiplatform networking library";
    homepage = https://www.libsdl.org/projects/SDL_net;
    license = licenses.zlib;
    maintainers = with maintainers; [ MP2E ];
    platforms = platforms.linux;
  };
}
