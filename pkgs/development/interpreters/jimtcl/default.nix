{ stdenv, fetchFromGitHub, sqlite, readline, asciidoc, SDL, SDL_gfx }:

stdenv.mkDerivation {
  name = "jimtcl-0.76";

  src = fetchFromGitHub {
    owner = "msteveb";
    repo = "jimtcl";
    rev = "51f65c6d38fbf86e1f0b036ad336761fd2ab7fa0";
    sha256 = "00ldal1w9ysyfmx28xdcaz81vaazr1fqixxb2abk438yfpp1i9hq";
  };

  buildInputs = [
    sqlite readline asciidoc SDL SDL_gfx
  ];

  NIX_CFLAGS_COMPILE = [ "-I${SDL.dev}/include/SDL" ];

  configureFlags = [
    "--with-ext=oo"
    "--with-ext=tree"
    "--with-ext=binary"
    "--with-ext=sqlite3"
    "--with-ext=readline"
    "--with-ext=sdl"
    "--enable-utf8"
    "--ipv6"
  ];

  meta = {
    description = "An open source small-footprint implementation of the Tcl programming language";
    homepage = http://jim.tcl.tk/;
    license = stdenv.lib.licenses.bsd2;
    platforms = stdenv.lib.platforms.all;
    maintainers = with stdenv.lib.maintainers; [ dbohdan vrthra ];
  };
}
