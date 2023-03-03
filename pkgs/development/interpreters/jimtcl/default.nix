{ lib
, stdenv
, fetchFromGitHub

, asciidoc
, pkg-config
, inetutils

, sqlite
, readline
, SDL
, SDL_gfx
}:

stdenv.mkDerivation rec {
  pname = "jimtcl";
  version = "0.81";

  src = fetchFromGitHub {
    owner = "msteveb";
    repo = "jimtcl";
    rev = version;
    sha256 = "sha256-OpM9y7fQ+18qxl3/5wUCrNA9qiCdA0vTHqLYSw2lvJs=";
  };

  nativeBuildInputs = [
    pkg-config
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

  enableParallelBuilding = true;

  doCheck = true;
  preCheck = ''
    # test exec2-3.2 fails depending on platform or sandboxing (?)
    rm tests/exec2.test
  '';

  # test posix-1.6 needs the "hostname" command
  nativeCheckInputs = [ inetutils ];

  postInstall = ''
    ln -sr $out/lib/libjim.so.${version} $out/lib/libjim.so
  '';

  meta = {
    description = "An open source small-footprint implementation of the Tcl programming language";
    homepage = "http://jim.tcl.tk/";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ dbohdan fgaz vrthra ];
  };
}
