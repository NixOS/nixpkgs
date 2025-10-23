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
    sha256 = "0cbpahn9flrv9ppp5xakhwh8vyyy7wzlsz22i3s93yqg9q2bh4ys";
  };

  meta = {
    homepage = "https://gnu-octave.github.io/packages/fpl/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "Collection of routines to export data produced by Finite Elements or Finite Volume Simulations in formats used by some visualization programs";
  };
}
