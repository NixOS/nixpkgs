{ stdenv, fetchFromGitHub, unzip, pkgconfig, makeWrapper, ncurses }:

stdenv.mkDerivation rec {
  name = "qnial-${version}";
  version = "6.3";

  src = fetchFromGitHub {
    sha256 = "0426hb8w0wpkisvmf3danj656j6g7rc6v91gqbgzkcj485qjaliw";
    rev = "cfe8720a4577d6413034faa2878295431bfe39f8";
    repo = "qnial";
    owner = "vrthra";
  };

  nativeBuildInputs = [ makeWrapper ];

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
     unzip
     pkgconfig
     ncurses
  ];

  meta = {
    description = "An array language from Nial Systems";
    homepage = https://github.com/vrthra/qnial;
    license = stdenv.lib.licenses.artistic1;
    maintainers = [ stdenv.lib.maintainers.vrthra ];
    platforms = stdenv.lib.platforms.linux;
  };
}
