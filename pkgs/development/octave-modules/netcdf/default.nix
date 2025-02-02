{ buildOctavePackage
, lib
, fetchurl
, netcdf
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

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/netcdf/index.html";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "NetCDF interface for Octave";
  };
}
