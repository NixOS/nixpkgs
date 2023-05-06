{ buildOctavePackage
, lib
, fetchurl
}:

buildOctavePackage rec {
  pname = "sockets";
  version = "1.4.0";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-GNwFLNV1u3UKJp9lhLtCclD2VSKC9Mko1hBoSn5dTpI=";
  };

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/sockets/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Socket functions for networking from within octave";
  };
}
