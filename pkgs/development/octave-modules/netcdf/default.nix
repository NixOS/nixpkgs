{ buildOctavePackage
, lib
, fetchurl
, netcdf
}:

buildOctavePackage rec {
  pname = "netcdf";
  version = "1.0.14";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "1wdwl76zgcg7kkdxjfjgf23ylzb0x4dyfliffylyl40g6cjym9lf";
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
