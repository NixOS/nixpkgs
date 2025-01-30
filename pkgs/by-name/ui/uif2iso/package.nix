{
  lib,
  stdenv,
  fetchurl,
  unzip,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "uif2iso";
  version = "0.1.7";

  src = fetchurl {
    url = "http://aluigi.altervista.org/mytoolz/uif2iso.zip";
    sha256 = "1v18fmlzhkkhv8xdc9dyvl8vamwg3ka4dsrg7vvmk1f2iczdx3dp";
  };

  nativeBuildInputs = [ unzip ];
  buildInputs = [ zlib ];

  installPhase = ''
    make -C . prefix="$out" install;
  '';

  meta = {
    description = "Tool for converting single/multi part UIF image files to ISO";
    homepage = "http://aluigi.org/mytoolz.htm#uif2iso";
    license = lib.licenses.gpl1Plus;
    platforms = lib.platforms.linux;
    mainProgram = "uif2iso";
  };
}
