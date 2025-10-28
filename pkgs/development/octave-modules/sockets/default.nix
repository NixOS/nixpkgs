{
  buildOctavePackage,
  lib,
  fetchurl,
}:

buildOctavePackage rec {
  pname = "sockets";
  version = "1.4.1";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-u5Nb9PVyMoR0lIzXEMtkZntXbBfpyXrtLB8U+dkgYrc=";
  };

  meta = {
    homepage = "https://gnu-octave.github.io/packages/sockets/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "Socket functions for networking from within octave";
  };
}
