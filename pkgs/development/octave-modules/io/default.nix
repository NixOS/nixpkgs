{ buildOctavePackage
, lib
, fetchurl
, enableJava
, jdk
, unzip
}:

buildOctavePackage rec {
  pname = "io";
  version = "2.6.3";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "044y8lfp93fx0592mv6x2ss0nvjkjgvlci3c3ahav76pk1j3rikb";
  };

  buildInputs = [
    (lib.optional enableJava jdk)
  ];

  propagatedBuildInputs = [
    unzip
  ];

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/io/index.html";
    license = with licenses; [ gpl3Plus bsd2 ];
    maintainers = with maintainers; [ KarlJoad ];
    description = "Input/Output in external formats";
  };
}
