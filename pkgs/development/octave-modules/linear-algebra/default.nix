{
  buildOctavePackage,
  lib,
  fetchurl,
}:

buildOctavePackage rec {
  pname = "linear-algebra";
  version = "2.2.4";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-Sc2FpNZxKKo2xRSOshcUPxTg69VgNQvQttJPkGMIsoo=";
  };

  meta = {
    homepage = "https://gnu-octave.github.io/packages/linear-algebra/";
    license = with lib.licenses; [
      gpl3Plus
      lgpl3Plus
    ];
    # They claim to have a FreeBSD license, but none of their code seems to have it.
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "Additional linear algebra code, including matrix functions";
  };
}
