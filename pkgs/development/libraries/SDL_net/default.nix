{ stdenv, fetchurl, SDL }:

stdenv.mkDerivation rec {
  pname = "SDL_net";
  version = "1.2.8";

  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://www.libsdl.org/projects/SDL_net/release/${name}.tar.gz";
    sha256 = "1d5c9xqlf4s1c01gzv6cxmg0r621pq9kfgxcg3197xw4p25pljjz";
  };

  propagatedBuildInputs = [ SDL ];

  meta = with stdenv.lib; {
    description = "SDL networking library";
    platforms = platforms.unix;
    license = licenses.zlib;
    homepage = "https://www.libsdl.org/projects/SDL_net/release-1.2.html";
  };
}
