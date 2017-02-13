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
    name = "netcdf-4.4.1.1";
    src = fetchurl {
        url = "http://www.unidata.ucar.edu/downloads/netcdf/ftp/${name}.tar.gz";
        sha256 = "1blc7ik5yin7i0ls2kag0a9xjk12m0dzx6v1x88az3ras3scci2d";
    };

    buildInputs = [ hdf5 m4 curl mpi];

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
    };
}
