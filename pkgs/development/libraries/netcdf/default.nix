{ stdenv, fetchurl,
  zlib, hdf5, m4,
  curl # for DAP
}:
    
stdenv.mkDerivation rec {
    name = "netcdf-4.3.3.1";
    src = fetchurl {
        url = "http://www.unidata.ucar.edu/downloads/netcdf/ftp/${name}.tar.gz";
        sha256 = "06ds8zm4qvjlqvv4qb637cqr0xgvbhnghrddisad5vj81s5kvpmx";
    };

    buildInputs = [
        zlib hdf5 m4 curl
    ];

    configureFlags = [
        "--enable-netcdf-4"
        "--enable-dap"
        "--enable-shared"
    ];
}
