{ buildOctavePackage
, lib
, fetchhg
, matgeom
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

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/geometry/index.html";
    license = with licenses; [ gpl3Plus boost ];
    maintainers = with maintainers; [ KarlJoad ];
    description = "Library for extending MatGeom functionality";
  };
}
