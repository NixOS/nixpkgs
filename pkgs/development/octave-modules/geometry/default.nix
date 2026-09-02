{
  buildOctavePackage,
  lib,
  fetchurl,
  matgeom,
  gsl,
}:

buildOctavePackage rec {
  pname = "geometry";
  version = "4.1.0";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-28FliEXJfS1mh8FJCmG0PTWZE9M0IOR1tlnzNfejQ2A=";
  };

  requiredOctavePackages = [
    matgeom
  ];

  buildInputs = [
    gsl
  ];

  meta = {
    homepage = "https://gnu-octave.github.io/packages/geometry/";
    license = with lib.licenses; [
      gpl3Plus
      boost
    ];
    maintainers = with lib.maintainers; [ ravenjoad ];
    description = "Library for extending MatGeom functionality";
  };
}
