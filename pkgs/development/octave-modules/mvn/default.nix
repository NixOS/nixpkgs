{
  buildOctavePackage,
  lib,
  fetchurl,
}:

buildOctavePackage rec {
  pname = "mvn";
  version = "1.1.0";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    hash = "sha256-r1oWuRy2uD7wW6YjIfwbipDI/n7nmk/IGbVhiztMhgM=";
  };

  meta = {
    homepage = "https://gnu-octave.github.io/packages/mvn/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ravenjoad ];
    description = "Multivariate normal distribution clustering and utility functions";
  };
}
