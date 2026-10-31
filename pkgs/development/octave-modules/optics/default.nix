{
  buildOctavePackage,
  lib,
  fetchurl,
}:

buildOctavePackage rec {
  pname = "optics";
  version = "0.1.4";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    hash = "sha256-7OXpX7HuxVtAO92zRjCwO6DpLwj87VBRrj+oQIRAP7U=";
  };

  meta = {
    homepage = "https://gnu-octave.github.io/packages/optics/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ravenjoad ];
    description = "Functions covering various aspects of optics";
  };
}
