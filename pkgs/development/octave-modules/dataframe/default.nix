{
  buildOctavePackage,
  lib,
  fetchurl,
}:

buildOctavePackage rec {
  pname = "dataframe";
  version = "1.2.0";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "10ara084gkb7d5vxv9qv7zpj8b4mm5y06nccrdy3skw5nfbb4djx";
  };

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/dataframe/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Data manipulation toolbox similar to R data.frame";
  };
}
