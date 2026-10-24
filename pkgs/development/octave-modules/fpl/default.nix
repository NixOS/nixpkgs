{
  buildOctavePackage,
  lib,
  fetchurl,
}:

buildOctavePackage rec {
  pname = "fpl";
  version = "1.3.5";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    hash = "sha256-2hO4BE4P+5H0iEJ8TT8/3vuNIIdT9XLvTTtTlyxUdzE=";
  };

  meta = {
    homepage = "https://gnu-octave.github.io/packages/fpl/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ravenjoad ];
    description = "Collection of routines to export data produced by Finite Elements or Finite Volume Simulations in formats used by some visualization programs";
  };
}
