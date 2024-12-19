{
  buildOctavePackage,
  lib,
  fetchurl,
  enableJava,
  jdk,
  unzip,
}:

buildOctavePackage rec {
  pname = "io";
  version = "2.6.4";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-p0pAC70ZIn9sB8WFiS3oec165S2CDaH2nxo+PolFL1o=";
  };

  buildInputs = [
    (lib.optional enableJava jdk)
  ];

  propagatedBuildInputs = [
    unzip
  ];

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/io/index.html";
    license = with licenses; [
      gpl3Plus
      bsd2
    ];
    maintainers = with maintainers; [ KarlJoad ];
    description = "Input/Output in external formats";
  };
}
