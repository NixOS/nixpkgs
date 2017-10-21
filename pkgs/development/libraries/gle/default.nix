{stdenv, fetchurl, mesa, freeglut, libX11, libXt, libXmu, libXi, libXext}:
stdenv.mkDerivation {
  name = "gle-3.1.0";
  buildInputs = [mesa freeglut libX11 libXt libXmu libXi libXext];
  src = fetchurl {
    urls = [
      "mirror://sourceforge/project/gle/gle/gle-3.1.0/gle-3.1.0.tar.gz"
      "http://www.linas.org/gle/pub/gle-3.1.0.tar.gz"
      ];
    sha256 = "09zs1di4dsssl9k322nzildvf41jwipbzhik9p43yb1bcfsp92nw";
  };
  meta = {
    description = ''Tubing and extrusion library'';
    license = stdenv.lib.licenses.gpl2 ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
