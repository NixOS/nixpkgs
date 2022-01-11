{ lib
, stdenv
, fetchurl
, unzip
, zlib
}:

stdenv.mkDerivation rec {
  pname = "atasm";
  version = "1.09";

  src = fetchurl {
    url = "https://atari.miribilist.com/${pname}/${pname}${builtins.replaceStrings ["."] [""] version}.zip";
    hash = "sha256-26shhw2r30GZIPz6S1rf6dOLKRpgpLwrqCRZX3+8PvA=";
  };

  patches = [
    # make install fails because atasm.txt was moved; report to upstream
    ./0000-file-not-found.diff
    # select flags for compilation
    ./0001-select-flags.diff
  ];

  dontConfigure = true;

  nativeBuildInputs = [
    unzip
  ];

  buildInputs = [
    zlib
  ];

  preBuild = ''
    makeFlagsArray+=(
      -C ./src
      CC=cc
      USEZ="-DZLIB_CAPABLE -I${zlib}/include"
      ZLIB="-L${zlib}/lib -lz"
      UNIX="-DUNIX"
    )
  '';

  preInstall = ''
    install -d $out/share/doc/${pname} $out/man/man1
    installFlagsArray+=(
      DESTDIR=$out
      DOCDIR=$out/share/doc/${pname}
      MANDIR=$out/man/man1
    )
  '';

  postInstall = ''
    mv docs/* $out/share/doc/${pname}
  '';

  meta = with lib; {
    homepage = "https://atari.miribilist.com/atasm/";
    description = "A commandline 6502 assembler compatible with Mac/65";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = with platforms; unix;
  };
}
