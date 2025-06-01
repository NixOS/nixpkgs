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
  version = "2.7.0";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-SqSEaLNpeTS/jIVOJ9uriCdgXp3U/jflaDQmXmEwum8=";
  };

  buildInputs = [
    (lib.optional enableJava jdk)
  ];

  propagatedBuildInputs = [
    unzip
  ];

  meta = {
    homepage = "https://gnu-octave.github.io/packages/io/";
    license = with lib.licenses; [
      gpl3Plus
      bsd2
    ];
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "Input/Output in external formats";
  };
}
