{ buildOctavePackage
, lib
, fetchurl
, netcdf
}:

buildOctavePackage rec {
  pname = "netcdf";
  version = "1.0.16";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-1Lr+6xLRXxSeUhM9+WdCUPFRZSWdxtAQlxpiv4CHJrs=";
  };

  buildInputs = [
    netcdf
  ];

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/netcdf/index.html";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "A NetCDF interface for Octave";
  };
}
