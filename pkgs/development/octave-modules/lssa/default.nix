{
  buildOctavePackage,
  lib,
  fetchurl,
}:

buildOctavePackage rec {
  pname = "lssa";
  version = "0.1.4";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    hash = "sha256-8IOUlNuK/Fn+KqBEYBNf1hXwUDALFH/iSBDfE/WnCYI=";
  };

  meta = {
    homepage = "https://gnu-octave.github.io/packages/lssa/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ravenjoad ];
    description = "Tools to compute spectral decompositions of irregularly-spaced time series";
    longDescription = ''
      A package implementing tools to compute spectral decompositions of
      irregularly-spaced time series. Currently includes functions based off
      the Lomb-Scargle periodogram and Adolf Mathias' implementation for R
      and C.
    '';
  };
}
