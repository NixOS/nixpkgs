{ stdenv, fetchurl,
  zlib, hdf5,
  curl # for DAP
}:
    
stdenv.mkDerivation rec {
    name = "netcdf-4.3.2";
    src = fetchurl {
        url = "http://www.unidata.ucar.edu/downloads/netcdf/ftp/${name}.tar.gz";
        sha256 = "57086b4383ce9232f05aad70761c2a6034b1a0c040260577d369b3bbfe6d248e";
    };

    buildInputs = [
        zlib hdf5 curl
    ];

    configureFlags = [
        "--enable-netcdf-4"
        "--enable-dap"
        "--enable-shared"
    ];
}
