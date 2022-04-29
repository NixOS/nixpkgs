{ buildOctavePackage
, lib
, fetchurl
, pkg-config
, nettle
}:

buildOctavePackage rec {
  pname = "general";
  version = "2.1.1";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "0jmvczssqz1aa665v9h8k9cchb7mg3n9af6b5kh9b2qcjl4r9l7v";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    nettle
  ];

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/general/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "General tools for Octave";
  };
}
