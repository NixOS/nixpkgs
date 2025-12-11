{
  buildOctavePackage,
  lib,
  fetchhg,
  matgeom,
}:

buildOctavePackage rec {
  pname = "geometry";
  version = "unstable-2021-07-07";

  src = fetchhg {
    url = "http://hg.code.sf.net/p/octave/${pname}";
    rev = "04965cda30b5f9e51774194c67879e7336df1710";
    sha256 = "sha256-ECysYOJMF4gPiCFung9hFSlyyO60X3MGirQ9FlYDix8=";
  };

  requiredOctavePackages = [
    matgeom
  ];

  meta = {
    homepage = "https://gnu-octave.github.io/packages/geometry/";
    license = with lib.licenses; [
      gpl3Plus
      boost
    ];
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "Library for extending MatGeom functionality";
  };
}
