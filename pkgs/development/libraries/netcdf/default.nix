{ stdenv, fetchurl }:
    
stdenv.mkDerivation {
    name = "netcdf-4.1.1";
    src = fetchurl {
        url = http://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-4.1.1.tar.gz;
        sha256 = "1c1g6ig24fn1fm5wwzv4w832li2jikblvbjv6wwg0mwc6yfxccvr";
    };
}