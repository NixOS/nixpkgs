{
  buildOctavePackage,
  lib,
  fetchurl,
}:

buildOctavePackage rec {
  pname = "struct";
  version = "1.0.18";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-/M6n3YTBEE7TurtHoo8F4AEqicKE85qwlAkEUJFSlM4=";
  };

  meta = {
    homepage = "https://gnu-octave.github.io/packages/struct/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "Additional structure manipulation functions";
  };
}
