{ buildOctavePackage
, lib
, fetchurl
, netcdf
, statistics
}:

buildOctavePackage rec {
  pname = "ncarray";
  version = "1.0.4";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "0v96iziikvq2v7hczhbfs9zmk49v99kn6z3lgibqqpwam175yqgd";
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
