{ stdenv, fetchFromGitHub, sqlite, readline, asciidoc, SDL, SDL_gfx }:

let
  makeSDLFlags = map (p: "-I${stdenv.lib.getDev p}/include/SDL");

in stdenv.mkDerivation rec {
  pname = "jimtcl";
  version = "0.79";

  src = fetchFromGitHub {
    owner = "msteveb";
    repo = "jimtcl";
    rev = version;
    sha256 = "1k88hz0v3bi19xdvlp0i9nsx38imzwpjh632w7326zwbv2wldf0h";
  };

  nativeBuildInputs = [
    asciidoc
  ];

  buildInputs = [
    sqlite readline SDL SDL_gfx
  ];

  configureFlags = [
    "--shared"
    "--with-ext=oo"
    "--with-ext=tree"
    "--with-ext=binary"
    "--with-ext=sqlite3"
    "--with-ext=readline"
    "--with-ext=sdl"
    "--with-ext=json"
    "--enable-utf8"
    "--ipv6"
  ];

  NIX_CFLAGS_COMPILE = toString (makeSDLFlags [ SDL SDL_gfx ]);

  enableParallelBuilding = true;

  doCheck = true;
  preCheck = ''
    # test exec2-3.2 fails depending on platform or sandboxing (?)
    rm tests/exec2.test
  '';

  postInstall = ''
    ln -sr $out/lib/libjim.so.${version} $out/lib/libjim.so
  '';

  meta = {
    description = "An open source small-footprint implementation of the Tcl programming language";
    homepage = "http://jim.tcl.tk/";
    license = stdenv.lib.licenses.bsd2;
    platforms = stdenv.lib.platforms.all;
    maintainers = with stdenv.lib.maintainers; [ dbohdan vrthra ];
  };
}
