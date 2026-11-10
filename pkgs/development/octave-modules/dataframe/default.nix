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
    hash = "sha256-XTaylrOFTz18y4xZA3yplSwk7z8bp913aWfNRxBQWYE=";
  };

  meta = {
    homepage = "https://gnu-octave.github.io/packages/dataframe/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ravenjoad ];
    description = "Data manipulation toolbox similar to R data.frame";
  };
}
