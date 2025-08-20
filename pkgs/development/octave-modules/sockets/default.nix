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

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/sockets/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Socket functions for networking from within octave";
  };
}
