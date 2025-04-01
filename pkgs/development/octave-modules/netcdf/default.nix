{
  buildOctavePackage,
  lib,
  fetchurl,
  netcdf,
}:

buildOctavePackage rec {
  pname = "netcdf";
  version = "1.0.17";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-uuFD8VNeWbyHFyWMDMzWDd2n+dG9EFmc/JnZU2tx+Uk=";
  };

  buildInputs = [
    netcdf
  ];

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/netcdf/index.html";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "NetCDF interface for Octave";
  };
}
