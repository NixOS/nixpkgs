{
  buildOctavePackage,
  lib,
  fetchurl,
  netcdf,
  statistics,
}:

buildOctavePackage rec {
  pname = "ncarray";
  version = "1.0.6";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-W6L2Esm7AdzntT7cimKylbeKYcZWKhHim96N5dM/qoE=";
  };

  buildInputs = [
    netcdf
  ];

  requiredOctavePackages = [
    statistics
  ];

  meta = {
    homepage = "https://gnu-octave.github.io/packages/ncarray/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "Access a single or a collection of NetCDF files as a multi-dimensional array";
  };
}
