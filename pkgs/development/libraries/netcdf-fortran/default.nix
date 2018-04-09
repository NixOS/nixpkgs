{ stdenv, fetchurl, netcdf, hdf5, curl, gfortran }:
stdenv.mkDerivation rec {
  name = "netcdf-fortran-${version}";
  version = "4.4.4";

  src = fetchurl {
    url = "https://github.com/Unidata/netcdf-fortran/archive/v${version}.tar.gz";
    sha256 = "0rwybszj1jjb25cx8vfyrd77x5qsdjzwspcjz56n12br89n9ica4";
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
