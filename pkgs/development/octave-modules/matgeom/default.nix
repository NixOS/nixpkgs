{
  buildOctavePackage,
  lib,
  fetchurl,
}:

buildOctavePackage rec {
  pname = "matgeom";
  version = "1.2.4";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-azRPhwMVvydCyojA/rXD2og1tPTL0vii15OveYQF+SA=";
  };

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/matgeom/index.html";
    license = with licenses; [
      bsd2
      gpl3Plus
    ];
    maintainers = with maintainers; [ KarlJoad ];
    description = "Geometry toolbox for 2D/3D geometric computing";
  };
}
