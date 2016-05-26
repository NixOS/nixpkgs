{ stdenv, fetchurl,
  zlib, hdf5, m4,
  curl, # for DAP
  mpiEnabled ? false,
  openmpi, hdf5-mpi # For parallel I/O
}:
    
stdenv.mkDerivation rec {
    name = "netcdf-4.3.3.1";
    src = fetchurl {
        url = "http://www.unidata.ucar.edu/downloads/netcdf/ftp/${name}.tar.gz";
        sha256 = "06ds8zm4qvjlqvv4qb637cqr0xgvbhnghrddisad5vj81s5kvpmx";
    };

    buildInputs = [
        ( if mpiEnabled == true then hdf5-mpi else hdf5 )
        zlib m4 curl
    ]
    ++ (stdenv.lib.optionals mpiEnabled [ openmpi ]);

    configureFlags = [
        "--enable-netcdf-4"
        "--enable-dap"
        "--enable-shared"
    ]
    ++ (stdenv.lib.optionals mpiEnabled [ "--enable-parallel-tests" ]);
}
