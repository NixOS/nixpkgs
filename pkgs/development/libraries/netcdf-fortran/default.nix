{ stdenv, fetchurl, netcdf, hdf5, curl, gfortran }:
stdenv.mkDerivation rec {
  name = "netcdf-fortran-${version}";
  version = "4.4.5";

  src = fetchurl {
    url = "https://github.com/Unidata/netcdf-fortran/archive/v${version}.tar.gz";
    sha256 = "00qwg4v250yg8kxp68srrnvfbfim241fnlm071p9ila2mihk8r01";
  };

  buildInputs = [ netcdf hdf5 curl gfortran ];
  doCheck = true;

  meta = with stdenv.lib; {
    description = "Fortran API to manipulate netcdf files";
    homepage = https://www.unidata.ucar.edu/software/netcdf/;
    license = licenses.free;
    maintainers = [ maintainers.bzizou ];
    platforms = platforms.unix;
  };
}
