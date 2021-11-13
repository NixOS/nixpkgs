{ lib, stdenv, fetchzip, netcdf, netcdfcxx4, gsl, udunits, antlr2, which, curl, flex, coreutils }:

stdenv.mkDerivation rec {
  pname = "nco";
  version = "5.0.3";

  src = fetchzip {
    url = "https://github.com/nco/nco/archive/${version}.tar.gz";
    sha256 = "sha256-KrFRBlD3z/sjKIvxmE0s/xCILQmESecilnlUGzDDICw=";
  };

  nativeBuildInputs = [ flex which antlr2 ];

  buildInputs = [ netcdf netcdfcxx4 gsl udunits curl coreutils ];

  postPatch = ''
    substituteInPlace src/nco/nco_fl_utl.c \
      --replace "/bin/cp" "${coreutils}/bin/cp"
    substituteInPlace src/nco/nco_fl_utl.c \
      --replace "/bin/mv" "${coreutils}/bin/mv"
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "NetCDF Operator toolkit";
    longDescription = "The NCO (netCDF Operator) toolkit manipulates and analyzes data stored in netCDF-accessible formats, including DAP, HDF4, and HDF5";
    homepage = "http://nco.sourceforge.net/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bzizou ];
    platforms = platforms.linux;
  };
}
