{ buildOctavePackage
, lib
, fetchurl
, pkg-config
, nettle
}:

buildOctavePackage rec {
  pname = "general";
  version = "2.1.2";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-owzRp5dDxiUo2uRuvUqD+EiuRqHB2sPqq8NmYtQilM8=";
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
