{ stdenv
, fetchurl
, hdf5
, m4
, curl # for DAP
}:

let
  mpiSupport = hdf5.mpiSupport;
  mpi = hdf5.mpi;
in stdenv.mkDerivation rec {
  name = "netcdf-4.6.0";

  src = fetchurl {
    url = "https://www.unidata.ucar.edu/downloads/netcdf/ftp/${name}.tar.gz";
    sha256 = "099qmdjj059wkj5za13zqnz0lcziqkcvyfdf894j4n6qq4c5iw2b";
  };

  nativeBuildInputs = [ m4 ];
  buildInputs = [ hdf5 curl mpi ];

  passthru = {
    mpiSupport = mpiSupport;
    inherit mpi;
  };

  configureFlags = [
      "--enable-netcdf-4"
      "--enable-dap"
      "--enable-shared"
  ]
  ++ (stdenv.lib.optionals mpiSupport [ "--enable-parallel-tests" "CC=${mpi}/bin/mpicc" ]);

  meta = {
      platforms = stdenv.lib.platforms.unix;
      homepage = https://www.unidata.ucar.edu/software/netcdf/;
  };
}
