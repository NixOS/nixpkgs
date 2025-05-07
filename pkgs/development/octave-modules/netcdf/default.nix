{
  buildOctavePackage,
  lib,
  fetchurl,
  netcdf,
}:

buildOctavePackage rec {
  pname = "netcdf";
  version = "1.0.18";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-ydgcKFh4uWuSlr7zw+k1JFUSzGm9tiWmOHV1IWvlgwk=";
  };

  propagatedBuildInputs = [
    netcdf
  ];

  meta = {
    homepage = "https://gnu-octave.github.io/packages/netcdf/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "NetCDF interface for Octave";
  };
}
