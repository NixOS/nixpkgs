{
  lib,
  stdenv,
  fetchurl,
  libglut,
  libX11,
  libXt,
  libXmu,
  libXi,
  libXext,
  libGL,
  libGLU,
}:
stdenv.mkDerivation rec {
  pname = "gle";
  version = "3.1.0";
  buildInputs = [
    libGLU
    libGL
    libglut
    libX11
    libXt
    libXmu
    libXi
    libXext
  ];
  src = fetchurl {
    urls = [
      "mirror://sourceforge/project/gle/gle/gle-${version}/gle-${version}.tar.gz"
      "https://www.linas.org/gle/pub/gle-${version}.tar.gz"
    ];
    sha256 = "09zs1di4dsssl9k322nzildvf41jwipbzhik9p43yb1bcfsp92nw";
  };
  meta = {
    description = "Tubing and extrusion library";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.linux;
  };
}
