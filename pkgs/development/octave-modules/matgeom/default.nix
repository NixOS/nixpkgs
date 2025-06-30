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

  meta = {
    homepage = "https://gnu-octave.github.io/packages/matgeom/";
    license = with lib.licenses; [
      bsd2
      gpl3Plus
    ];
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "Geometry toolbox for 2D/3D geometric computing";
  };
}
