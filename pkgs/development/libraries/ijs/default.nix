{ lib, stdenv, autoreconfHook, ghostscript }:

stdenv.mkDerivation {
  name = "ijs-${ghostscript.version}";

  inherit (ghostscript) src;

  postPatch = "cd ijs";

  enableParallelBuilding = true;

  nativeBuildInputs = [ autoreconfHook ];

  configureFlags = [ "--enable-shared" ];

  meta = with lib; {
    homepage = "https://www.openprinting.org/download/ijs/";
    description = "Raster printer driver architecture";

    license = licenses.gpl3Plus;

    platforms = platforms.all;
    maintainers = [ maintainers.abbradar ];
  };
}
