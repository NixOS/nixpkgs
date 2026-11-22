{
  buildOctavePackage,
  lib,
  fetchurl,
}:

buildOctavePackage rec {
  pname = "cgi";
  version = "0.1.2";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    hash = "sha256-QYfrKr7GnFc1Un/j1qJbIBD8zt4Zn+VW4kJnftmRz0M=";
  };

  meta = {
    homepage = "https://gnu-octave.github.io/packages/cgi/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ ravenjoad ];
    description = "Common Gateway Interface for Octave";
  };
}
