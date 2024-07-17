{
  lib,
  stdenv,
  fetchurl,
  gd,
  giflib,
  groff,
  libpng,
  tk,
}:

stdenv.mkDerivation rec {
  pname = "npiet";
  version = "1.3f";

  src = fetchurl {
    url = "https://www.bertnase.de/npiet/npiet-${version}.tar.gz";
    sha256 = "sha256-Le2FYGKr1zWZ6F4edozmvGC6LbItx9aptidj3KBLhVo=";
  };

  buildInputs = [
    gd
    giflib
    libpng
  ];

  nativeBuildInputs = [ groff ];

  postPatch = ''
    # malloc.h is not needed because stdlib.h is already included.
    # On macOS, malloc.h does not even exist, resulting in an error.
    substituteInPlace npiet-foogol.c \
        --replace '#include <malloc.h>' ""

    substituteInPlace npietedit \
        --replace 'exec wish' 'exec ${tk}/bin/wish'
  '';

  meta = with lib; {
    description = "An interpreter for piet programs. Also includes npietedit and npiet-foogol";
    longDescription = ''
      npiet is an interpreter for the piet programming language.
      Instead of text, piet programs are pictures. Commands are determined based on changes in color.
    '';
    homepage = "https://www.bertnase.de/npiet/";
    license = licenses.gpl2Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ Luflosi ];
  };
}
