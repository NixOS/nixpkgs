{ buildOctavePackage
, lib
, fetchurl
}:

buildOctavePackage rec {
  pname = "matgeom";
  version = "1.2.3";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "12q66dy4ninhki3jslzcamfblcb3cdkfbbzn3a5har1s212lsfiw";
  };

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/matgeom/index.html";
    license = with licenses; [ bsd2 gpl3Plus ];
    maintainers = with maintainers; [ KarlJoad ];
    description = "Geometry toolbox for 2D/3D geometric computing";
  };
}
