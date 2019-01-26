{ stdenv, fetchFromGitHub, sqlite, readline, asciidoc, SDL, SDL_gfx }:

let
  makeSDLFlags = map (p: "-I${stdenv.lib.getDev p}/include/SDL");

in stdenv.mkDerivation rec {
  name = "jimtcl-${version}";
  version = "0.78";

  src = fetchFromGitHub {
    owner = "msteveb";
    repo = "jimtcl";
    rev = version;
    sha256 = "1nrjxjfh69i35ig8sxdlal4ydd3cl0x68c05s6svnf1y2i1bl23j";
  };

  buildInputs = [
    sqlite readline asciidoc SDL SDL_gfx
  ];

  NIX_CFLAGS_COMPILE = makeSDLFlags [ SDL SDL_gfx ];

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
