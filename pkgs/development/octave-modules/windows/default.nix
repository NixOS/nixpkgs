{
  buildOctavePackage,
  lib,
  fetchurl,
}:

buildOctavePackage rec {
  pname = "windows";
  version = "1.6.5";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-j/goQc57jcfxlCsbf31Mx8oNud1vNE0D/hNfXyvVmTc=";
  };

  meta = {
    homepage = "https://gnu-octave.github.io/packages/windows/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "Provides COM interface and additional functionality on Windows";
  };
}
