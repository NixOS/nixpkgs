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

  meta = {
    homepage = "https://gnu-octave.github.io/packages/dataframe/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "Data manipulation toolbox similar to R data.frame";
  };
}
