{ buildOctavePackage
, lib
, fetchurl
, matgeom
}:

buildOctavePackage rec {
  pname = "geometry";
  version = "4.0.0";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "1zmd97xir62fr5v57xifh2cvna5fg67h9yb7bp2vm3ll04y41lhs";
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
