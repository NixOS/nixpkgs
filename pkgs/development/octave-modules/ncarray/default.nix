{ buildOctavePackage
, lib
, fetchurl
, netcdf
, statistics
}:

buildOctavePackage rec {
  pname = "ncarray";
  version = "1.0.5";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-HhQWLUA/6wqYi6TP3PC+N2zgi4UojDxbG9pgQzFaQ8c=";
  };

  buildInputs = [
    netcdf
  ];

  requiredOctavePackages = [
    statistics
  ];

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/ncarray/index.html";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Access a single or a collection of NetCDF files as a multi-dimensional array";
  };
}
