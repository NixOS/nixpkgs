{
  buildOctavePackage,
  lib,
  fetchurl,
}:

buildOctavePackage rec {
  pname = "divand";
  version = "1.1.2";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    hash = "sha256-r6qQadrvOuD9mpuxAxt8L7wD5+eVEkXu+dS1M2T5qlo=";
  };

  meta = {
    homepage = "https://gnu-octave.github.io/packages/divand/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ ravenjoad ];
    description = "Performs an n-dimensional variational analysis (interpolation) of arbitrarily located observations";
  };
}
