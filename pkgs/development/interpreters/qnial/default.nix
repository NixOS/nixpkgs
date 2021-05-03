{ lib, stdenv, fetchFromGitHub, unzip, pkg-config, makeWrapper, ncurses }:

stdenv.mkDerivation {
  pname = "qnial";
  version = "6.3";

  src = fetchFromGitHub {
    sha256 = "0426hb8w0wpkisvmf3danj656j6g7rc6v91gqbgzkcj485qjaliw";
    rev = "cfe8720a4577d6413034faa2878295431bfe39f8";
    repo = "qnial";
    owner = "vrthra";
  };

  nativeBuildInputs = [ makeWrapper unzip ];

  preConfigure = ''
    cd build;
  '';

  installPhase = ''
    cd ..
    mkdir -p $out/bin $out/lib
    cp build/nial $out/bin/
    cp -r niallib $out/lib/
  '';

  buildInputs = [
     pkg-config
     ncurses
  ];

  meta = {
    description = "An array language from Nial Systems";
    homepage = "https://github.com/vrthra/qnial";
    license = lib.licenses.artistic1;
    maintainers = [ lib.maintainers.vrthra ];
    platforms = lib.platforms.linux;
  };
}
