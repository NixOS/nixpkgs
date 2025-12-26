{
  buildOctavePackage,
  lib,
  fetchurl,
}:

buildOctavePackage rec {
  pname = "mvn";
  version = "1.1.0";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "00w69hxqnqdm3744z6p7gvzci44a3gy228x6bgq3xf5n3jwicnmg";
  };

  meta = {
    homepage = "https://gnu-octave.github.io/packages/mvn/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "Multivariate normal distribution clustering and utility functions";
  };
}
