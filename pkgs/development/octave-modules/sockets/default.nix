{ buildOctavePackage
, lib
, fetchurl
}:

buildOctavePackage rec {
  pname = "sockets";
  version = "1.2.1";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "18f1zpqcf6h9b4fb0x2c5nvc3mvgj1141f1s8d9gnlhlrjlq8vqg";
  };

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/sockets/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Socket functions for networking from within octave";
  };
}
