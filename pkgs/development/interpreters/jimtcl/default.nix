{ lib
, stdenv
, fetchFromGitHub

, asciidoc
, pkg-config
, inetutils
, tcl

, sqlite
, readline
, SDL
, SDL_gfx
, openssl

, SDLSupport ? true
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jimtcl";
  version = "0.82";

  src = fetchFromGitHub {
    owner = "msteveb";
    repo = "jimtcl";
    rev = finalAttrs.version;
    sha256 = "sha256-CDjjrxpoTbLESAbCiCjQ8+E/oJP87gDv9SedQOzH3QY=";
  };

  nativeBuildInputs = [
    pkg-config
    asciidoc
    tcl
  ];

  buildInputs = [
    sqlite
    readline
    openssl
  ] ++ (lib.optionals SDLSupport [
    SDL
    SDL_gfx
  ]);

  configureFlags = [
    "--shared"
    "--with-ext=oo"
    "--with-ext=tree"
    "--with-ext=binary"
    "--with-ext=sqlite3"
    "--with-ext=readline"
    "--with-ext=json"
    "--enable-utf8"
    "--ipv6"
  ] ++ (lib.optional SDLSupport "--with-ext=sdl");

  enableParallelBuilding = true;

  doCheck = true;
  preCheck = ''
    # test exec2-3.2 fails depending on platform or sandboxing (?)
    rm tests/exec2.test
    # requires internet access
    rm tests/ssl.test
    # test fails due to timing in some environments
    # https://github.com/msteveb/jimtcl/issues/282
    rm tests/timer.test
  '';

  # test posix-1.6 needs the "hostname" command
  nativeCheckInputs = [ inetutils ];

  meta = {
    description = "Open source small-footprint implementation of the Tcl programming language";
    homepage = "http://jim.tcl.tk/";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ dbohdan fgaz vrthra ];
  };
})
