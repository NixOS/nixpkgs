{
  lib,
  stdenv,
  fetchurl,
  cmake,
  boost,
  gmp,
  mpfr,
}:

stdenv.mkDerivation rec {
  pname = "cgal";
  version = "5.6.2";

  src = fetchurl {
    url = "https://github.com/CGAL/cgal/releases/download/v${version}/CGAL-${version}.tar.xz";
    hash = "sha256-RY9g346PHy/a2TyPJOGqj0sJXMYaFPrIG5BoDXMGpC4=";
  };

  # note: optional component libCGAL_ImageIO would need zlib and opengl;
  #   there are also libCGAL_Qt{3,4} omitted ATM
  buildInputs = [
    boost
    gmp
    mpfr
  ];
  nativeBuildInputs = [ cmake ];

  patches = [ ./cgal_path.patch ];

  doCheck = false;

  meta = with lib; {
    description = "Computational Geometry Algorithms Library";
    homepage = "http://cgal.org";
    license = with licenses; [
      gpl3Plus
      lgpl3Plus
    ];
    platforms = platforms.all;
    maintainers = [ maintainers.raskin ];
  };
}
